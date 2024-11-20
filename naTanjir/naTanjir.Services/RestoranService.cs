using MapsterMapper;
using Microsoft.EntityFrameworkCore;
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
    public class RestoranService : BaseCRUDServiceAsync<Model.Restoran, RestoranSearchObject, Database.Restoran, RestoranInsertRequest, RestoranUpdateRequest>, IRestoranService
    {
        private readonly IRestoranValidatorService restoranValidator;

        public RestoranService(NaTanjirContext context, IMapper mapper, 
            IRestoranValidatorService restoranValidator) : base(context, mapper)
        {
            this.restoranValidator = restoranValidator;
        }

        public override IQueryable<Restoran> AddFilter(RestoranSearchObject searchObject, IQueryable<Restoran> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.NazivGTE))
            {
                query = query.Where(x => x.Naziv.StartsWith(searchObject.NazivGTE));
            }

            if(searchObject.VrstaRestoranaId!=null)
            {
                query = query.Where(x => searchObject.VrstaRestoranaId.Contains(x.VrstaRestoranaId));
            }
            if (searchObject.VlasnikId != null)
            {
                query = query.Where(x => x.VlasnikId == searchObject.VlasnikId);
            }
            if (searchObject.IsVrstaRestoranaIncluded == true)
            {
                query = query.Include(x => x.VrstaRestorana);
            }
            if (!string.IsNullOrWhiteSpace(searchObject.VrstaRestoranaNazivGTE))
            {
                query = query.Where(x => x.VrstaRestorana.Naziv.Contains(searchObject.VrstaRestoranaNazivGTE));
            }
            if (searchObject?.IsDeleted != null)
            {
                if (searchObject.IsDeleted == false)
                {
                    query = query.Where(x => x.IsDeleted == false || x.IsDeleted == null);
                }
                else
                {
                    query = query.Where(x => x.IsDeleted == true);
                }
            }

            return query;
        }

        public override async Task BeforeInsertAsync(RestoranInsertRequest request, Restoran entity, CancellationToken cancellationToken = default)
        {
            restoranValidator.ValidateRestoranIns(request);

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeUpdateAsync(RestoranUpdateRequest request, Restoran entity, CancellationToken cancellationToken = default)
        {
            await base.BeforeUpdateAsync(request, entity, cancellationToken);

            restoranValidator.ValidateRestoranUpd(request);
        }

       
    }
}
