using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.Auth;
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
    public class OcjenaRestoranService : BaseCRUDServiceAsync<Model.OcjenaRestoran, OcjenaRestoranSearchObject, Database.OcjenaRestoran, OcjenaRestoranInsertRequest, OcjenaRestoranUpdateRequest>, IOcjenaRestoranService
    {
        private readonly IOcjenaRestoranValidatorService ocjenaRestoranValidator;

        public OcjenaRestoranService(NaTanjirContext context, IMapper mapper, 
            IOcjenaRestoranValidatorService ocjenaRestoranValidator) : base(context, mapper)
        {
            this.ocjenaRestoranValidator = ocjenaRestoranValidator;
        }

        public override IQueryable<OcjenaRestoran> AddFilter(OcjenaRestoranSearchObject searchObject, IQueryable<OcjenaRestoran> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.RestoranNazivGTE))
            {
                query = query.Include(x => x.Restoran).Where(x => x.Restoran.Naziv.StartsWith(searchObject.RestoranNazivGTE));
            }

            if(searchObject.DatumKreiranjaGTE!=null)
            {
                query = query.Where(x => x.DatumKreiranja > searchObject.DatumKreiranjaGTE);
            }

            if(searchObject.DatumKreiranjaLTE!=null)
            {
                query = query.Where(x => x.DatumKreiranja < searchObject.DatumKreiranjaLTE);
            }

            if (searchObject.OcjenaGTE != null)
            {
                query = query.Where(x => x.Ocjena > searchObject.OcjenaGTE);
            }

            if (searchObject.OcjenaLTE != null)
            {
                query = query.Where(x => x.Ocjena < searchObject.OcjenaLTE);
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

            if (searchObject.IsKorisnikIncluded == true)
            {
                query = query.Include(x => x.Korisnik);
            }

            if (searchObject.IsDeleted == true)
            {
                query = query.Where(x => x.IsDeleted == searchObject.IsDeleted);
            }

            return query;
        }

        public override async Task BeforeInsertAsync(OcjenaRestoranInsertRequest request, OcjenaRestoran entity, CancellationToken cancellationToken = default)
        {
            ocjenaRestoranValidator.ValidateOcjenaRestorantIns(request);

            //fix date
            if (request?.DatumKreiranja == null)
            {
                entity.DatumKreiranja = DateTime.Now;
            }

            if (request?.Ocjena == null || request.Ocjena <= 0 || request.Ocjena > 5)
            {
                throw new UserException("Molimo unesite validnu ocjenu između 1 i 5.");
            }
            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeUpdateAsync(OcjenaRestoranUpdateRequest request, OcjenaRestoran entity, CancellationToken cancellationToken = default)
        {
            await base.BeforeUpdateAsync(request, entity, cancellationToken);

            if (request?.DatumKreiranja == null)
            {
                entity.DatumKreiranja = DateTime.Now;
            }

            if (request?.Ocjena == null || request.Ocjena <= 0 || request.Ocjena > 5)
            {
                throw new UserException("Molimo unesite validnu ocjenu između 1 i 5.");
            }

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite stauts ocjene.");
            }
        }
    }
}
