using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.Database;
using naTanjir.Services.Validator.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public class RestoranFavoritService : BaseCRUDService<Model.RestoranFavorit, RestoranFavoritSearchObject, Database.RestoranFavorit, RestoranFavoritInsertRequest, RestoranFavoritUpdateRequest>, IRestoranFavoritService
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

        public override void BeforeInsert(RestoranFavoritInsertRequest request, RestoranFavorit entity)
        {
            restoranFavoritValidator.ValidateRestoranFavoritIns(request);

            if (request?.DatumDodavanja == null)
            {
                entity.DatumDodavanja = DateTime.Now;
            }

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(RestoranFavoritUpdateRequest request, RestoranFavorit entity)
        {
            base.BeforeUpdate(request, entity);

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite status");
            }
        }
    }
}
