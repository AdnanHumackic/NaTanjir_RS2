
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.BaseServices.Implementation;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public class LokacijaService : BaseCRUDServiceAsync<Model.Lokacija, LokacijaSearchObject, Database.Lokacija, LokacijaInsertRequest, LokacijaUpdateRequest>, ILokacijaService
    {
        public LokacijaService(NaTanjirContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Lokacija> AddFilter(LokacijaSearchObject searchObject, IQueryable<Lokacija> query)
        {
            query = base.AddFilter(searchObject, query);

            if (searchObject.IsDeleted == true)
            {
                query = query.Where(x => x.IsDeleted == searchObject.IsDeleted);
            }

            return query;
        }

        public override async Task BeforeInsertAsync(LokacijaInsertRequest request, Lokacija entity, CancellationToken cancellationToken = default)
        {
            if (!request.GeografskaDuzina.HasValue || !request.GeografskaSirina.HasValue ||
                 request.GeografskaDuzina.Value == 0 || request.GeografskaSirina.Value == 0)
            {
                throw new UserException("Molimo unesite validne podatke.");
            }

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeUpdateAsync(LokacijaUpdateRequest request, Lokacija entity, CancellationToken cancellationToken = default)
        {
            await base.BeforeUpdateAsync(request, entity, cancellationToken);

            if (!request.GeografskaDuzina.HasValue || !request.GeografskaSirina.HasValue ||
                request.GeografskaDuzina.Value == 0 || request.GeografskaSirina.Value == 0)
            {
                throw new UserException("Molimo unesite validne podatke.");
            }

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite status lokacije.");
            }
        }
    }
}
