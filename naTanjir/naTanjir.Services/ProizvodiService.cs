using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Client.Extensibility;
using naTanjir.Model;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.BaseServices.Implementation;
using naTanjir.Services.Database;
using naTanjir.Services.Recommender.OrderBased;
using naTanjir.Services.Validator.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public class ProizvodiService : BaseCRUDServiceAsync<Model.Proizvod, ProizvodiSearchObject, Database.Proizvod, ProizvodiInsertRequest, ProizvodiUpdateRequest>, IProizvodiService
    {
        private readonly IRecommenderService recommendService;
        private readonly IProizvodValidatorService proizvodValidator;
        public ProizvodiService(NaTanjirContext context, IMapper mapper,
            IRecommenderService recommenderService, IProizvodValidatorService proizvodValidator) : base(context, mapper)
        {
            this.recommendService=recommenderService;
            this.proizvodValidator = proizvodValidator;
        }

        public override IQueryable<Database.Proizvod> AddFilter(ProizvodiSearchObject searchObject, IQueryable<Database.Proizvod> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.NazivGTE))
            {
                query = query.Where(x => x.Naziv.StartsWith(searchObject.NazivGTE));
            }
            if (searchObject.RestoranId != null)
            {
                query = query.Where(x => searchObject.RestoranId.Contains(x.RestoranId));
            }
            if (searchObject.VlasnikRestoranaId != null)
            {
                query = query.Where(x => x.Restoran.VlasnikId == searchObject.VlasnikRestoranaId);
            }
            if (searchObject.VrstaProizvodaId != null)
            {
                query = query.Where(x => searchObject.VrstaProizvodaId.Contains(x.VrstaProizvodaId));
            }
            if (!string.IsNullOrWhiteSpace(searchObject.NazivRestoranaGTE))
            {
                query = query.Where(x => x.Restoran.Naziv.Contains(searchObject.NazivRestoranaGTE));
            }
            if (!string.IsNullOrWhiteSpace(searchObject.VrstaProizvodaNazivGTE))
            {
                query = query.Where(x => x.VrstaProizvoda.Naziv.Contains(searchObject.VrstaProizvodaNazivGTE));
            }
            if (searchObject.IsVrstaIncluded == true)
            {
                query = query.Include(x=>x.VrstaProizvoda);
            }
            if (searchObject.IsRestoranIncluded == true)
            {
                query = query.Include(x => x.Restoran);
            }
            if (searchObject?.IsDeleted != null)
            {
                if (searchObject.IsDeleted == false)
                {
                    query = query.Where(x => x.IsDeleted == false || x.IsDeleted == null);
                }
                else
                {
                    query = query.Where(x => x.IsDeleted == true);
                }
            }
            return query;
        }

        public override async Task BeforeInsertAsync(ProizvodiInsertRequest request, Database.Proizvod entity, CancellationToken cancellationToken = default)
        {
            proizvodValidator.ValidateProizvodIns(request);
            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeUpdateAsync(ProizvodiUpdateRequest request, Database.Proizvod entity, CancellationToken cancellationToken = default)
        {
            await base.BeforeUpdateAsync(request, entity, cancellationToken);
            proizvodValidator.ValidateProizvodUpd(request);
        }

        public async Task<List<Model.Proizvod>> Recommend(int id)
        {
            var proizvodi = await recommendService.GetRecommendedProducts(id);

            return proizvodi;
        }
        public void TrainData()
        {
            recommendService.TrainData();
        }
    }
}
