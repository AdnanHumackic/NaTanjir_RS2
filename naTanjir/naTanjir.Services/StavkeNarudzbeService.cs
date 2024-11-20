
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
    public class StavkeNarudzbeService : BaseCRUDServiceAsync<Model.StavkeNarudzbe, StavkeNarudzbeSearchObject, Database.StavkeNarudzbe, StavkeNarudzbeInsertRequest, StavkeNarudzbeUpdateRequest>, IStavkeNarudzbe
    {
        public StavkeNarudzbeService(NaTanjirContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<StavkeNarudzbe> AddFilter(StavkeNarudzbeSearchObject searchObject, IQueryable<StavkeNarudzbe> query)
        {
            query = base.AddFilter(searchObject, query);
           
            if (searchObject.CijenaGTE != null)
            {
                query = query.Where(x => x.Cijena > searchObject.CijenaGTE);
            }
            if (searchObject.CijenaLTE!= null)
            {
                query = query.Where(x => x.Cijena < searchObject.CijenaLTE);
            }

            if (searchObject.NarudzbaId != null)
            {
                query = query.Where(x => x.NarudzbaId == searchObject.NarudzbaId);
            }

            if (searchObject.ProizvodId != null)
            {
                query = query.Where(x => x.ProizvodId == searchObject.ProizvodId);
            }

            if (searchObject.RestoranId != null)
            {
                query = query.Where(x => x.RestoranId == searchObject.RestoranId);
            }

            if (searchObject.IsProizvodIncluded != null)
            {
                query = query.Include(x => x.Proizvod);
            }
            if (searchObject.IsRestoranIncluded != null)
            {
                query = query.Include(x => x.Restoran);
            }
            if (searchObject.IsDeleted == true)
            {
                query = query.Include(x => x.IsDeleted);
            }

            return query;
        }
    }
}
