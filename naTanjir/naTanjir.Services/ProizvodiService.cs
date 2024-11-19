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

        public ProizvodiService(NaTanjirContext context, IMapper mapper,
            IRecommenderService recommenderService) : base(context, mapper)
        {
            this.recommendService=recommenderService;
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
            if (string.IsNullOrWhiteSpace(request.Naziv))
            {
                throw new UserException("Molimo unesite naziv proizvoda.");
            }

            if (string.IsNullOrWhiteSpace(request.Opis))
            {
                throw new UserException("Molimo unesite opis proizvoda.");
            }

            if (request?.Cijena == null || request.Cijena <= 0)
            {
                throw new UserException("Molimo unesite validnu cijenu.");
            }

            if (request.VrstaProizvodaId == 0 || request?.VrstaProizvodaId == null)
            {
                throw new UserException("Molimo unesite tip proizvoda.");
            }

            if (request.RestoranId == 0 || request?.RestoranId == null)
            {
                throw new UserException("Molimo unesite restoran kojem proizvod pripada.");
            }

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeUpdateAsync(ProizvodiUpdateRequest request, Database.Proizvod entity, CancellationToken cancellationToken = default)
        {
            await base.BeforeUpdateAsync(request, entity, cancellationToken);

            if (string.IsNullOrWhiteSpace(request.Naziv))
            {
                throw new UserException("Molimo unesite naziv proizvoda.");
            }

            if (string.IsNullOrWhiteSpace(request.Opis))
            {
                throw new UserException("Molimo unesite opis proizvoda.");
            }

            if (request.Cijena == 0 || request.Cijena < 0)
            {
                throw new UserException("Molimo unesite validnu cijenu.");
            }

            if (request.VrstaProizvodaId == 0 || request?.VrstaProizvodaId == null)
            {
                throw new UserException("Molimo unesite tip proizvoda.");
            }

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite status restorana.");
            }
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
