using MapsterMapper;
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
    public class VrstaRestoranaService : BaseCRUDService<Model.VrstaRestorana, VrstaRestoranaSearchObject, Database.VrstaRestorana, VrstaRestoranaInsertRequest, VrstaRestoranaUpdateRequest>, IVrstaRestoranaService
    {
        public VrstaRestoranaService(NaTanjirContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<VrstaRestorana> AddFilter(VrstaRestoranaSearchObject searchObject, IQueryable<VrstaRestorana> query)
        {
            query = base.AddFilter(searchObject, query);

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

        public override void BeforeInsert(VrstaRestoranaInsertRequest request, Database.VrstaRestorana entity)
        {
            if (string.IsNullOrWhiteSpace(request.Naziv))
            {
                throw new Exception("Molimo unseite naziv za vrstu restorana.");
            }

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(VrstaRestoranaUpdateRequest request, Database.VrstaRestorana entity)
        {
            base.BeforeUpdate(request, entity);

            if (string.IsNullOrWhiteSpace(request.Naziv))
            {
                throw new Exception("Molimo unseite naziv za vrstu proizvoda.");
            }

            if (request?.IsDeleted == null)
            {
                throw new Exception("Molime unesite status vrste restorana.");
            }
        }
    }
}
