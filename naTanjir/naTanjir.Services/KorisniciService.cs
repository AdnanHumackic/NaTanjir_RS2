using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using naTanjir.Model;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.BaseServices.Implementation;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public class KorisniciService:BaseCRUDService<Model.Korisnici, KorisniciSearchObject, Database.Korisnici, KorisniciInsertRequest, KorisniciUpdateRequest>, IKorisniciService
    {

        ILogger<KorisniciService> _logger;
        public KorisniciService(NaTanjirContext context, IMapper mapper, ILogger<KorisniciService> logger) : base(context, mapper)
        {
            _logger = logger;
        }

        public override IQueryable<Database.Korisnici> AddFilter(KorisniciSearchObject searchObject, IQueryable<Database.Korisnici> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.ImeGTE))
            {
                query = query.Where(x => x.Ime.StartsWith(searchObject.ImeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject.PrezimeGTE))
            {
                query = query.Where(x => x.Prezime.StartsWith(searchObject.PrezimeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject.Email))
            {
                query = query.Where(x => x.Email == searchObject.Email);
            }

            if (!string.IsNullOrWhiteSpace(searchObject.KorisnickoIme))
            {
                query = query.Where(x => x.KorisnickoIme == searchObject.KorisnickoIme);
            }

            if (searchObject.IsKorisniciUlogeIncluded == true)
            {
                query = query.Include(x => x.KorisniciUloges).ThenInclude(x => x.Uloga);
            }

            if (searchObject.IsDeleted == true)
            {
                query = query.Where(x => x.IsDeleted == searchObject.IsDeleted);
            }
            
            return query;
        }
  
        public override void BeforeInsert(KorisniciInsertRequest request, Database.Korisnici entity)
        {
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new UserException("Lozinka i LozinkaPotvrda moraju biti iste.");
            }

            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.Lozinka);
            
            base.BeforeInsert(request, entity);
        }
        

        public static string GenerateSalt()
        {
            var byteArray = RNGCryptoServiceProvider.GetBytes(16);

            return Convert.ToBase64String(byteArray);
        }

        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public override void BeforeUpdate(KorisniciUpdateRequest request, Database.Korisnici entity)
        {
            base.BeforeUpdate(request, entity);

            if (request.Lozinka != null)
            {
                if (request.Lozinka != request.LozinkaPotvrda)
                {
                    throw new UserException("Lozinka i LozinkaPotvrda moraju biti iste.");
                }
                entity.LozinkaSalt = GenerateSalt();
                entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.Lozinka);
            }
        }

        public Model.Korisnici Login(string username, string password)
        {
            var entity = Context.Korisnicis.Include(x=>x.KorisniciUloges).ThenInclude(y=>y.Uloga).FirstOrDefault(x => x.KorisnickoIme == username);

            if (entity == null)
            {
                return null;
            }

            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }

            return Mapper.Map<Model.Korisnici>(entity);
        }
    }
}
