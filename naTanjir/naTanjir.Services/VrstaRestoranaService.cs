using MapsterMapper;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
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
    public class VrstaRestoranaService : BaseCRUDService<Model.VrstaRestorana, VrstaRestoranaSearchObject, Database.VrstaRestorana, VrstaRestoranaInsertRequest, VrstaRestoranaUpdateRequest>, IVrstaRestoranaService
    {
        private readonly IVrstaRestoranaValidatorService vrstaRestoranaValidator;

        public VrstaRestoranaService(NaTanjirContext context, IMapper mapper, 
            IVrstaRestoranaValidatorService vrstaRestoranaValidator) : base(context, mapper)
        {
            this.vrstaRestoranaValidator = vrstaRestoranaValidator;
        }

        public override IQueryable<Database.VrstaRestorana> AddFilter(VrstaRestoranaSearchObject searchObject, IQueryable<VrstaRestorana> query)
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
            vrstaRestoranaValidator.ValidateVrstaRestoranaNazivIns(request);

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(VrstaRestoranaUpdateRequest request, Database.VrstaRestorana entity)
        {
            base.BeforeUpdate(request, entity);

            vrstaRestoranaValidator.ValidateVrstaRestoranaNazivUpd(request);

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molime unesite status vrste restorana.");
            }
        }
    }
}
