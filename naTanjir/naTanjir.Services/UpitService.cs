using MapsterMapper;
using Microsoft.EntityFrameworkCore;
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
    public class UpitService : BaseCRUDServiceAsync<Model.Upit, UpitSearchObject, Database.Upit, UpitInsertRequest, UpitUpdateRequest>, IUpitService
    {
        public UpitService(NaTanjirContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Upit> AddFilter(UpitSearchObject searchObject, IQueryable<Upit> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.ImeGTE))
            {
                query=query.Include(x=>x.Korisnik)
                    .Where(x=>x.Korisnik.Ime.StartsWith(searchObject.ImeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject.PrezimeGTE))
            {
                query = query.Include(x => x.Korisnik)
                    .Where(x => x.Korisnik.Prezime.StartsWith(searchObject.PrezimeGTE));
            }
            if(!string.IsNullOrWhiteSpace(searchObject.ImePrezimeGTE)
                && string.IsNullOrWhiteSpace(searchObject.ImeGTE) 
                && string.IsNullOrWhiteSpace(searchObject.PrezimeGTE))
            {
                query = query.Include(x=>x.Korisnik)
                    .Where(x => (x.Korisnik.Ime + " " + x.Korisnik.Prezime).StartsWith(searchObject.ImePrezimeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject.RestoranNazivGTE))
            {
                query = query.Include(x => x.Restoran)
                    .Where(x => x.Restoran.Naziv.StartsWith(searchObject.RestoranNazivGTE));
            }

            if (searchObject.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (searchObject.RestoranId != null)
            {
                query = query.Where(x => x.RestoranId == searchObject.RestoranId);
            }

            if (searchObject.Odgovoreno == true)
            {
                query = query.Where(x => x.Odgovor != null);
            }

            return query;        
        }
    }
}
