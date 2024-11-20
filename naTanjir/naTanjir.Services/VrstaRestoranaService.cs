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
    public class VrstaRestoranaService : BaseCRUDServiceAsync<Model.VrstaRestorana, VrstaRestoranaSearchObject, Database.VrstaRestorana, VrstaRestoranaInsertRequest, VrstaRestoranaUpdateRequest>, IVrstaRestoranaService
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
        public override async Task BeforeInsertAsync(VrstaRestoranaInsertRequest request, VrstaRestorana entity, CancellationToken cancellationToken = default)
        {
            vrstaRestoranaValidator.ValidateVrstaRestoranaNazivIns(request);
            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeUpdateAsync(VrstaRestoranaUpdateRequest request, VrstaRestorana entity, CancellationToken cancellationToken = default)
        {
            await base.BeforeUpdateAsync(request, entity, cancellationToken);

            vrstaRestoranaValidator.ValidateVrstaRestoranaNazivUpd(request);

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molime unesite status vrste restorana.");
            }
        }
    }
}
