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
    public class KorpaService : BaseCRUDService<Model.Korpa, KorpaSearchObject, Database.Korpa, KorpaInsertRequest, KorpaUpdateRequest>, IKorpaService
    {
        public KorpaService(NaTanjirContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Korpa> AddFilter(KorpaSearchObject searchObject, IQueryable<Korpa> query)
        {
            query= base.AddFilter(searchObject, query);

            if (searchObject.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (searchObject.IsKorisnikIncluded == true)
            {
                query = query.Include(x => x.Korisnik);
            }

            return query;
        }


        public override void BeforeInsert(KorpaInsertRequest request, Korpa entity)
        {
            if (request?.KorisnikId == null || request?.KorisnikId==0)
            {
                throw new Exception("Molimo unesite korisnik id.");
            }

            base.BeforeInsert(request, entity);
        }
    }
}
