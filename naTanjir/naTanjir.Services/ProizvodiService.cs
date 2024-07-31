using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Client.Extensibility;
using naTanjir.Model;
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
    public class ProizvodiService : BaseCRUDService<Model.Proizvod, ProizvodiSearchObject, Database.Proizvod, ProizvodiInsertRequest, ProizvodiUpdateRequest>, IProizvodiService
    {
        public ProizvodiService(NaTanjirContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Proizvod> AddFilter(ProizvodiSearchObject searchObject, IQueryable<Database.Proizvod> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.NazivGTE))
            {
                query = query.Where(x => x.Naziv.StartsWith(searchObject.NazivGTE));
            }

            if (searchObject.VrstaProizvodaId!=null)
            {
                query = query.Where(x => x.VrstaProizvodaId==searchObject.VrstaProizvodaId);
            }

            if (searchObject.IsVrstaIncluded == true)
            {
                query = query.Include(x=>x.VrstaProizvoda);
            }

            if (searchObject.IsDeleted == true)
            {
                query = query.Where(x=>x.IsDeleted==searchObject.IsDeleted);
            }
            return query;
        }

        public override void BeforeInsert(ProizvodiInsertRequest request, Database.Proizvod entity)
        {
            if (string.IsNullOrWhiteSpace(request.Naziv))
            {
                throw new Exception("Molimo unesite naziv proizvoda.");
            }

            if (string.IsNullOrWhiteSpace(request.Opis))
            {
                throw new Exception("Molimo unesite opis proizvoda.");
            }

            if (request?.Cijena == null || request.Cijena <= 0)
            {
                throw new Exception("Molimo unesite validnu cijenu.");
            }

            if (request.VrstaProizvodaId == 0 || request?.VrstaProizvodaId==null)
            {
                throw new Exception("Molimo unesite tip proizvoda.");
            }

            if(request.RestoranId==0 || request?.RestoranId==null)
            {
                throw new Exception("Molimo unesite restoran kojem proizvod pripada.");
            }

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(ProizvodiUpdateRequest request, Database.Proizvod entity)
        {
            base.BeforeUpdate(request, entity);

            if (string.IsNullOrWhiteSpace(request.Naziv))
            {
                throw new Exception("Molimo unesite naziv proizvoda.");
            }

            if (string.IsNullOrWhiteSpace(request.Opis))
            {
                throw new Exception("Molimo unesite opis proizvoda.");
            }

            if (request.Cijena==0 || request.Cijena<0)
            {
                throw new Exception("Molimo unesite validnu cijenu.");
            }

            if (request.VrstaProizvodaId == 0 || request?.VrstaProizvodaId==null)
            {
                throw new Exception("Molimo unesite tip proizvoda.");
            }

            if (request?.IsDeleted == null)
            {
                throw new Exception("Molimo unesite status restorana.");
            }
        }

       
    }
}
