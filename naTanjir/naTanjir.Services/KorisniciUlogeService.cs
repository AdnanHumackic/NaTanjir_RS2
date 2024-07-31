using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.SqlServer.Query.Internal;
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
    public class KorisniciUlogeService : BaseCRUDService<Model.KorisniciUloge, KorisniciUlogeSearchObject, Database.KorisniciUloge, KorisniciUlogeInsertRequest, KorisniciUlogeUpdateRequest>, IKorisniciUloge
    {
        public KorisniciUlogeService(NaTanjirContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.KorisniciUloge> AddFilter(KorisniciUlogeSearchObject searchObject, IQueryable<Database.KorisniciUloge> query)
        {
            query = base.AddFilter(searchObject, query);

            if (searchObject.KorisnikId!=null)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (searchObject.UlogaId != null)
            {
                query = query.Where(x => x.UlogaId== searchObject.UlogaId);
            }

            if (searchObject.IsUlogaIncluded == true)
            {
                query = query.Include(x => x.Uloga);
            }

            if (searchObject.IsDeleted == true)
            {
                query = query.Where(x => x.IsDeleted == searchObject.IsDeleted);
            }

            return query;
        }

        public override void BeforeInsert(KorisniciUlogeInsertRequest request, Database.KorisniciUloge entity)
        {
            if(request.KorisnikId==0 || request?.KorisnikId == null)
            {
                throw new Exception("Molimo unesite id korisnika.");
            }

            if (request.UlogaId == 0 || request?.UlogaId == null)
            {
                throw new Exception("Molimo unesite id uloge.");
            }

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(KorisniciUlogeUpdateRequest request, Database.KorisniciUloge entity)
        {
            base.BeforeUpdate(request, entity);

            if (request?.IsDeleted == null)
            {
                throw new Exception("Molimo unesite status.");
            }
        }
    }
}
