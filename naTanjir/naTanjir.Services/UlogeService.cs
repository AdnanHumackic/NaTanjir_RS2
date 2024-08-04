using MapsterMapper;
using naTanjir.Model.Exceptions;
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
    public class UlogeService : BaseCRUDService<Model.Uloge, UlogeSearchObject, Database.Uloge, UlogeInsertRequest, UlogeUpdateRequest>, IUlogeService
    {
      
        public UlogeService(NaTanjirContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Uloge> AddFilter(UlogeSearchObject searchObject, IQueryable<Database.Uloge> query)
        {
            query=base.AddFilter(searchObject, query);
        
            if(!string.IsNullOrWhiteSpace(searchObject.NazivGTE))
            {
                query = query.Where(x => x.Naziv.StartsWith(searchObject.NazivGTE));
            }

            if (searchObject?.IsDeleted == true)
            {
                query = query.Where(x => x.IsDeleted == searchObject.IsDeleted);
            }
            return query;
        }

        public override void BeforeInsert(UlogeInsertRequest request, Uloge entity)
        {
            if (string.IsNullOrWhiteSpace(request.Naziv))
            {
                throw new UserException("Molimo unesite naziv vrste restorana.");
            }

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(UlogeUpdateRequest request, Uloge entity)
        {
            base.BeforeUpdate(request, entity);

            if (string.IsNullOrWhiteSpace(request.Naziv))
            {
                throw new UserException("Molimo unesite naziv vrste restorana.");
            }

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite status uloge.");
            }
        }
    }
}
