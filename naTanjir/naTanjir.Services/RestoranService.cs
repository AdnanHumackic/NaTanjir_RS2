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
    public class RestoranService : BaseCRUDService<Model.Restoran, RestoranSearchObject, Database.Restoran, RestoranInsertRequest, RestoranUpdateRequest>, IRestoranService
    {
        private readonly IRestoranValidatorService restoranValidator;

        public RestoranService(NaTanjirContext context, IMapper mapper, 
            IRestoranValidatorService restoranValidator) : base(context, mapper)
        {
            this.restoranValidator = restoranValidator;
        }

        public override IQueryable<Restoran> AddFilter(RestoranSearchObject searchObject, IQueryable<Restoran> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.NazivGTE))
            {
                query = query.Where(x => x.Naziv.StartsWith(searchObject.NazivGTE));
            }

            if(searchObject.VrstaRestoranaId!=null)
            {
                query = query.Where(x => x.VrstaRestoranaId == searchObject.VrstaRestoranaId);
            }

            if (searchObject.IsVrstaRestoranaIncluded == true)
            {
                query = query.Include(x => x.VrstaRestorana);
            }

            if (searchObject.IsDeleted == true)
            {
                query = query.Where(x => x.IsDeleted == searchObject.IsDeleted);
            }

            return query;
        }


        public override void BeforeInsert(RestoranInsertRequest request, Restoran entity)
        {
            this.restoranValidator.ValidateRestoranIns(request);

            if (string.IsNullOrWhiteSpace(request.RadnoVrijemeOd))
            {
                throw new UserException("Molimo unesite radno vrijeme od.");
            }

            if (string.IsNullOrWhiteSpace(request.RadnoVrijemeDo))
            {
                throw new UserException("Molimo unesite radno vrijeme do.");
            }

            if (string.IsNullOrWhiteSpace(request.Lokacija))
            {
                throw new UserException("Molimo unesite lokaciju restorana.");
            }

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(RestoranUpdateRequest request, Restoran entity)
        {
            base.BeforeUpdate(request, entity);

            if (string.IsNullOrWhiteSpace(request.RadnoVrijemeOd))
            {
                throw new UserException("Molimo unesite radno vrijeme od.");
            }

            if (string.IsNullOrWhiteSpace(request.RadnoVrijemeDo))
            {
                throw new UserException("Molimo unesite radno vrijeme do.");
            }

            if (string.IsNullOrWhiteSpace(request.Lokacija))
            {
                throw new UserException("Molimo unesite lokaciju restorana.");
            }

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite status restorana.");
            }
        }
    }
}
