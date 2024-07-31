using MapsterMapper;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public class VrstaProizvodumService : BaseCRUDService<Model.VrstaProizvodum, VrstaProizvodumSearchObject, Database.VrstaProizvodum, VrstaProizvodumInsertRequest, VrstaProizvodumUpdateRequest>, IVrstaProizvodumService
    {
        public VrstaProizvodumService(NaTanjirContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<VrstaProizvodum> AddFilter(VrstaProizvodumSearchObject searchObject, IQueryable<VrstaProizvodum> query)
        {
            query=base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.NazivGTE))
            {
                query = query.Where(x => x.Naziv.StartsWith(searchObject.NazivGTE));
            }

            if (searchObject?.IsDeleted == true)
            {
                query = query.Where(x => x.IsDeleted == searchObject.IsDeleted);
            }
            return query;
        }

        public override void BeforeInsert(VrstaProizvodumInsertRequest request, VrstaProizvodum entity)
        {
            if (string.IsNullOrWhiteSpace(request.Naziv))
            {
                throw new Exception("Molimo unseite naziv za vrstu proizvoda.");
            }

            base.BeforeInsert(request, entity);
        }


        public override void BeforeUpdate(VrstaProizvodumUpdateRequest request, VrstaProizvodum entity)
        {
            base.BeforeUpdate(request, entity);

            if (string.IsNullOrWhiteSpace(request.Naziv))
            {
                throw new Exception("Molimo unseite naziv za vrstu proizvoda.");
            }

            if (request?.IsDeleted == null)
            {
                throw new Exception("Molimo unesite status za vrstu proizvoda.");
            }
        }
    }
}
