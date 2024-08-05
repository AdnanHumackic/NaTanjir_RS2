using MapsterMapper;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.Database;
using naTanjir.Services.Validator.Interfaces;
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
        private readonly IVrstaProizvodumValidatorService vrstaProizvodumValidator;

        public VrstaProizvodumService(NaTanjirContext context, IMapper mapper, 
            IVrstaProizvodumValidatorService vrstaProizvodumValidator) : base(context, mapper)
        {
            this.vrstaProizvodumValidator = vrstaProizvodumValidator;
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
            vrstaProizvodumValidator.ValidateVrstaProizvodumNazivIns(request);

            base.BeforeInsert(request, entity);
        }


        public override void BeforeUpdate(VrstaProizvodumUpdateRequest request, VrstaProizvodum entity)
        {
            base.BeforeUpdate(request, entity);

            vrstaProizvodumValidator.ValidateVrstaProizvodumNazivUpd(request);

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite status za vrstu proizvoda.");
            }
        }
    }
}
