
  using MapsterMapper;
using Microsoft.EntityFrameworkCore;
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
    public class LokacijaService : BaseCRUDService<Model.Lokacija, LokacijaSearchObject, Database.Lokacija, LokacijaInsertRequest, LokacijaUpdateRequest>, ILokacijaService
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

        public override void BeforeInsert(LokacijaInsertRequest request, Lokacija entity)
        {
            if (!request.GeografskaDuzina.HasValue || !request.GeografskaSirina.HasValue ||
                 request.GeografskaDuzina.Value == 0 || request.GeografskaSirina.Value == 0)
            {
                throw new UserException("Molimo unesite validne podatke.");
            }

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(LokacijaUpdateRequest request, Lokacija entity)
        {
            base.BeforeUpdate(request, entity);

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
