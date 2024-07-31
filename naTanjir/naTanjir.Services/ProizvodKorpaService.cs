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
    public class ProizvodKorpaService : BaseCRUDService<Model.ProizvodKorpa, ProizvodKorpaSearchObject, Database.ProizvodKorpa, ProizvodKorpaInsertRequest, ProizvodKorpaUpdateRequest>, IProizvodKorpaService
    {
        public ProizvodKorpaService(NaTanjirContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<ProizvodKorpa> AddFilter(ProizvodKorpaSearchObject searchObject, IQueryable<ProizvodKorpa> query)
        {
            query = base.AddFilter(searchObject, query);

            if (searchObject.ProizvodId != null)
            {
                query = query.Where(x => x.ProizvodId == searchObject.ProizvodId);
            }

            if (searchObject.KorpaId != null)
            {
                query = query.Where(x => x.KorpaId == searchObject.KorpaId);
            }
            

            if (searchObject.IsDeleted == true)
            {
                query = query.Where(x => x.IsDeleted == searchObject.IsDeleted);
            }
            return query;
        }

        public override void BeforeInsert(ProizvodKorpaInsertRequest request, ProizvodKorpa entity)
        {
            if(request?.ProizvodId==null || request.ProizvodId == 0)
            {
                throw new Exception("Molimo unesite proizvod id.");
            }
            
            if(request?.KorpaId==null || request.KorpaId == 0)
            {
                throw new Exception("Molimo unesite korpa id.");
            }
            if (request?.Kolicina == null || request.Kolicina <= 0 )
            {
                throw new Exception("Molimo unesite validnu kolicinu.");
            }
            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(ProizvodKorpaUpdateRequest request, ProizvodKorpa entity)
        {
            base.BeforeUpdate(request, entity);
           
            if (request?.ProizvodId == null || request.ProizvodId == 0)
            {
                throw new Exception("Molimo unesite proizvod id.");
            }

            if (request?.Kolicina == null || request.Kolicina <= 0)
            {
                throw new Exception("Molimo unesite validnu kolicinu.");
            }

            if (request?.IsDeleted == null)
            {
                throw new Exception("Molimo unesite status.");
            }

        }
    }
}
