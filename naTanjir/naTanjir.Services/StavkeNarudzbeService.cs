
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
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
    public class StavkeNarudzbeService : BaseCRUDService<Model.StavkeNarudzbe, StavkeNarudzbeSearchObject, Database.StavkeNarudzbe, StavkeNarudzbeInsertRequest, StavkeNarudzbeUpdateRequest>, IStavkeNarudzbe
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

            if (searchObject.IsNarudzbaIncluded == true)
            {
                query = query.Include(x => x.Narudzba);
            }

            if (searchObject.IsProizvodIncluded == true)
            {
                query = query.Include(x => x.Proizvod);
            }

            if (searchObject.IsKorisnikIncluded == true)
            {
                query = query.Include(x => x.Proizvod);
            }

            if (searchObject.IsDeleted == true)
            {
                query = query.Include(x => x.IsDeleted);
            }

            return query;
        }

        public override void BeforeInsert(StavkeNarudzbeInsertRequest request, StavkeNarudzbe entity)
        {
            if(request?.Kolicina==null || request.Kolicina <= 0)
            {
                throw new Exception("Molimo unesite validnu kolicinu.");
            }
            if (request?.Cijena == null || request.Cijena <= 0)
            {
                throw new Exception("Molimo unesite validnu kolicinu.");
            }
            if(request?.ProizvodId==null || request.ProizvodId == 0)
            {
                throw new Exception("Molimo unesite proizvod id.");
            }

            if(request?.RestoranId==null || request.RestoranId == 0)
            {
                throw new Exception("Molimo unesite restoran id.");
            }

            if (request?.NarudzbaId==0 || request?.NarudzbaId == null)
            {
                var narudzba = new Narudzba
                {
                    BrojNarudzbe=123,
                    DatumKreiranja=DateTime.Now,
                    IsDeleted=false,
                    IsDostavljena=false,
                    IsNaPutu=false,
                    KorisnikId=1,
                    UkupnaCijena=request.Kolicina*request.Cijena,
                    VrijemeBrisanja=null,
                };
                Context.Narudzbas.Add(narudzba);
                Context.SaveChanges();

                request.NarudzbaId = narudzba.NarudzbaId;
            }
            entity.NarudzbaId = request.NarudzbaId;
            base.BeforeInsert(request, entity);

          
        }
    }
}
