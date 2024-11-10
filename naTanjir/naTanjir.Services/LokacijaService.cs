
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
            if (searchObject.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }
            return query;
        }
      
    }
}
