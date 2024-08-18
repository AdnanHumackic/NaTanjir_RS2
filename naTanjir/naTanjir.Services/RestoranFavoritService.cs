using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.BaseServices.Implementation;
using naTanjir.Services.Database;
using naTanjir.Services.Validator.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public class RestoranFavoritService : BaseCRUDServiceAsync<Model.RestoranFavorit, RestoranFavoritSearchObject, Database.RestoranFavorit, RestoranFavoritInsertRequest, RestoranFavoritUpdateRequest>, IRestoranFavoritService
    {
        private readonly IRestoranFavoritValidatorService restoranFavoritValidator;

        public RestoranFavoritService(NaTanjirContext context, IMapper mapper, 
            IRestoranFavoritValidatorService restoranFavoritValidator) : base(context, mapper)
        {
            this.restoranFavoritValidator = restoranFavoritValidator;
        }

        public override IQueryable<RestoranFavorit> AddFilter(RestoranFavoritSearchObject searchObject, IQueryable<RestoranFavorit> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.RestoranNazivGTE))
            {
                query = query.Include(x => x.Restoran).Where(x => x.Restoran.Naziv.StartsWith(searchObject.RestoranNazivGTE));
            }

            if (searchObject.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (searchObject.RestoranId != null)
            {
                query = query.Where(x => x.RestoranId == searchObject.RestoranId);
            }


            if (searchObject.IsRestoranIncluded == true)
            {
                query = query.Include(x => x.Restoran);
            }

            if (searchObject.IsDeleted == true)
            {
                query = query.Where(x => x.IsDeleted == searchObject.IsDeleted);
            }

            return query;
        }

        public override async Task BeforeInsertAsync(RestoranFavoritInsertRequest request, RestoranFavorit entity, CancellationToken cancellationToken = default)
        {
            restoranFavoritValidator.ValidateRestoranFavoritIns(request);

            if (request?.DatumDodavanja == null)
            {
                entity.DatumDodavanja = DateTime.Now;
            }

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeUpdateAsync(RestoranFavoritUpdateRequest request, RestoranFavorit entity, CancellationToken cancellationToken = default)
        {
            await base.BeforeUpdateAsync(request, entity, cancellationToken);

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite status");
            }
        }
       
    }
}
