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
    public class KorisniciService:BaseCRUDServiceAsync<Model.Korisnici, KorisniciSearchObject, Database.Korisnici, KorisniciInsertRequest, KorisniciUpdateRequest>, IKorisniciService
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

            if(!string.IsNullOrWhiteSpace(searchObject.ImePrezimeGTE)
                && string.IsNullOrWhiteSpace(searchObject.ImeGTE) 
                && string.IsNullOrWhiteSpace(searchObject.PrezimeGTE))
            {
                query = query.Where(x => (x.Ime + " " + x.Prezime).StartsWith(searchObject.ImePrezimeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject.EmailGTE))
            {
                query = query.Where(x => x.Email.ToLower().StartsWith(searchObject.EmailGTE.ToLower()));
            }

            if (!string.IsNullOrWhiteSpace(searchObject.Uloga))
            {
                query = query.Include(x => x.KorisniciUloges)
                    .Where(x => x.KorisniciUloges.Any(x => x.Uloga.Naziv == searchObject.Uloga));
            }
            if (!string.IsNullOrWhiteSpace(searchObject.KorisnickoIme))
            {
                query = query.Where(x => x.KorisnickoIme.StartsWith(searchObject.KorisnickoIme));
            }

            if (searchObject.IsKorisniciUlogeIncluded == true)
            {
                query = query.Include(x => x.KorisniciUloges).ThenInclude(x => x.Uloga);
            }
            if (searchObject.IsRestoranIncluded == true)
            {
                query = query.Include(x => x.Restoran);
            }
            if (searchObject.RestoranId != null)
            {
                query = query.Where(x => x.RestoranId.HasValue && searchObject.RestoranId.Contains(x.RestoranId.Value));
            }
            if (searchObject.VlasnikRestoranaId != null) 
            {
                query = query.Where(x => x.Restoran.VlasnikId == searchObject.VlasnikRestoranaId);
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

        public override async Task BeforeInsertAsync(KorisniciInsertRequest request, Database.Korisnici entity, CancellationToken cancellationToken = default)
        {
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new UserException("Lozinka i LozinkaPotvrda moraju biti iste.");
            }

            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.Lozinka);

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task AfterInsertAsync(KorisniciInsertRequest request, Database.Korisnici entity, CancellationToken cancellationToken = default)
        {
            if (request.Uloge != null)
            {
                foreach(var uloge in request.Uloge)
                {
                    Context.KorisniciUloges.Add(new Database.KorisniciUloge
                    {
                        KorisnikId=entity.KorisnikId,
                        UlogaId=uloge
                    });

                    await Context.SaveChangesAsync(cancellationToken);
                }
            }
            await base.AfterInsertAsync(request, entity, cancellationToken);
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

        public override async Task BeforeUpdateAsync(KorisniciUpdateRequest request, Database.Korisnici entity, CancellationToken cancellationToken = default)
        {
            await base.BeforeUpdateAsync(request, entity, cancellationToken);

            if (request.NovaLozinka != null)
            {
                if (request.NovaLozinka != request.LozinkaPotvrda)
                {
                    throw new UserException("Lozinka i LozinkaPotvrda moraju biti iste.");
                }
                entity.LozinkaSalt = GenerateSalt();
                entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, request.NovaLozinka);
            }
            entity.IsDeleted = false;
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
