using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.BaseServices.Implementation;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public class NarudzbaService : BaseCRUDService<Model.Narudzba, NarudzbaSearchObject, Database.Narudzba, NarudzbaInsertRequest, NarudzbaUpdateRequest>, INarudzbaService
    {
        public NarudzbaService(NaTanjirContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Narudzba> AddFilter(NarudzbaSearchObject searchObject, IQueryable<Narudzba> query)
        {
            query = base.AddFilter(searchObject, query);

            if (searchObject.BrojNarudzbe != null)
            {
                query = query.Where(x => x.BrojNarudzbe == searchObject.BrojNarudzbe);
            }

            if (searchObject.UkupnaCijena != null)
            {
                query = query.Where(x => x.UkupnaCijena == searchObject.UkupnaCijena);
            }

            if (searchObject.DatumKreiranja != null)
            {
                query = query.Where(x => x.DatumKreiranja == searchObject.DatumKreiranja);
            }

            if (searchObject.DatumKreiranjaGTE != null)
            {
                query = query.Where(x => x.DatumKreiranja > searchObject.DatumKreiranjaGTE);
            }

            if (searchObject.DatumKreiranjaLTE != null)
            {
                query = query.Where(x => x.DatumKreiranja < searchObject.DatumKreiranjaLTE);
            }

            if (searchObject.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (searchObject.RestoranId != null)
            {
                query = query.Include(x => x.StavkeNarudzbes.Where(x => x.RestoranId == searchObject.RestoranId)) ;
            }

            if (searchObject.IsKorisnikIncluded == true)
            {
                query = query.Include(x => x.Korisnik);
            }

            if (searchObject.IsStavkeNarudzbeIncluded == true)
            {
                query = query.Include(x => x.StavkeNarudzbes);
            }

            if (searchObject.IsDeleted == true)
            {
                query = query.Where(x => x.IsDeleted == searchObject.IsDeleted);
            }

            return query;
        }

        public override void BeforeInsert(NarudzbaInsertRequest request, Narudzba entity)
        {
            if(request?.KorisnikId==null || request.KorisnikId == 0)
            {
                throw new UserException("Molimo unesite korisnik id.");
            }

            if(request?.BrojNarudzbe==null || request.BrojNarudzbe == 0)
            {
                throw new UserException("Molimo unesite broj narudzbe.");
            }

            if(request?.UkupnaCijena==null || request.UkupnaCijena <= 0)
            {
                throw new UserException("Molimo unesite ukupnu cijenu koja mora bit veća od 0.");
            }

            if (request?.DatumKreiranja == null)
            {
                entity.DatumKreiranja = DateTime.Now;
            }

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(NarudzbaUpdateRequest request, Narudzba entity)
        {
            base.BeforeUpdate(request, entity);

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite stauts narudzbe.");
            }
        }
    }
}
