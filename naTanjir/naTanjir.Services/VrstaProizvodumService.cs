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
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public class VrstaProizvodumService : BaseCRUDServiceAsync<Model.VrstaProizvodum, VrstaProizvodumSearchObject, Database.VrstaProizvodum, VrstaProizvodumInsertRequest, VrstaProizvodumUpdateRequest>, IVrstaProizvodumService
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

        public override async Task BeforeInsertAsync(VrstaProizvodumInsertRequest request, VrstaProizvodum entity, CancellationToken cancellationToken = default)
        {
            vrstaProizvodumValidator.ValidateVrstaProizvodumNazivIns(request);
            await base.BeforeInsertAsync(request, entity, cancellationToken);

        }

        public override async Task BeforeUpdateAsync(VrstaProizvodumUpdateRequest request, VrstaProizvodum entity, CancellationToken cancellationToken = default)
        {
            await base.BeforeUpdateAsync(request, entity, cancellationToken);

            //vrstaProizvodumValidator.ValidateVrstaProizvodumNazivUpd(request);

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite status za vrstu proizvoda.");
            }
        }
       
    }
}
