using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public class OcjenaRestoranService : BaseCRUDService<Model.OcjenaRestoran, OcjenaRestoranSearchObject, Database.OcjenaRestoran, OcjenaRestoranInsertRequest, OcjenaRestoranUpdateRequest>, IOcjenaRestoranService
    {
        public OcjenaRestoranService(NaTanjirContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<OcjenaRestoran> AddFilter(OcjenaRestoranSearchObject searchObject, IQueryable<OcjenaRestoran> query)
        {
            query = base.AddFilter(searchObject, query);

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

        public override void BeforeInsert(OcjenaRestoranInsertRequest request, OcjenaRestoran entity)
        {
            if (request?.DatumKreiranja == null)
            {
                entity.DatumKreiranja = DateTime.Now;
            }

            if (request?.Ocjena == null || request.Ocjena <= 0 || request.Ocjena > 5)
            {
                throw new Exception("Molimo unesite validnu ocjenu između 1 i 5.");
            }

            if (request?.KorisnikId == null || request.KorisnikId==0)
            {
                throw new Exception("Molimo unesite korisnik id.");
            }

            if (request?.RestoranId == null || request.RestoranId==0)
            {
                throw new Exception("Molimo unesite restoran id.");
            }
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(OcjenaRestoranUpdateRequest request, OcjenaRestoran entity)
        {
            base.BeforeUpdate(request, entity);

            if (request?.DatumKreiranja == null)
            {
                entity.DatumKreiranja = DateTime.Now;
            }

            if (request?.Ocjena == null || request.Ocjena <= 0 || request.Ocjena > 5)
            {
                throw new Exception("Molimo unesite validnu ocjenu između 1 i 5.");
            }

            if (request?.IsDeleted == null)
            {
                throw new Exception("Molimo unesite stauts ocjene.");
            }

        }
    }
}
