using Microsoft.IdentityModel.Tokens;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Services.Database;
using naTanjir.Services.Validator.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Validator.Implementation
{
    public class KorisniciValidatorService : BaseValidatorService<Database.Korisnici>, IKorisniciValidatorService
    {
        private readonly NaTanjirContext Context;

        public KorisniciValidatorService(NaTanjirContext context) : base(context)
        {
            this.Context = context;
        }

        public void ValidateKorisniciIns(KorisniciInsertRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Ime))
            {
                throw new UserException("Molimo unesite ime.");
            }

            if (string.IsNullOrWhiteSpace(request.Prezime))
            {
                throw new UserException("Molimo unesite prezime.");

            }

            if (string.IsNullOrWhiteSpace(request.Email))
            {
                throw new UserException("Molimo unesite email.");

            }

            if (string.IsNullOrWhiteSpace(request.Telefon))
            {
                throw new UserException("Molimo unesite broj telefona.");

            }

            var korisnickoIme = Context.Korisnicis.Where(x => x.KorisnickoIme.ToLower() == request.KorisnickoIme.ToLower()).FirstOrDefault();

            if (korisnickoIme != null)
            {
                throw new UserException($"Korisnicko ime: {request.KorisnickoIme} je vec u upotrebi.");
            }

            if (request.DatumRodjenja == default)
            {
                throw new UserException("Molimo unesite datum rođenja.");
            }

            var danas = DateTime.Now;
            var razlikaGodina = danas.Year - request.DatumRodjenja.Year;

            if (request.DatumRodjenja.Date > danas.AddYears(-razlikaGodina))
            {
                razlikaGodina--;
            }

            if (razlikaGodina < 18)
            {
                throw new UserException("Korisnik mora imati najmanje 18 godina.");
            }

            if (request.Uloge == null || !request.Uloge.Any())
            {
                throw new UserException("Molimo odaberite barem jednu ulogu.");
            }

            var nevalidneUloge = request.Uloge
                .Where(u => !Context.Uloges.Any(z => z.UlogaId == u))
                .ToList();

            if (nevalidneUloge.Any())
            {
                throw new UserException($"Sljedeće uloge ne postoje: {string.Join(", ", nevalidneUloge)}.");
            }

            if (request.RestoranId.HasValue)
            {
                if (!Context.Restorans.Any(r => r.RestoranId == request.RestoranId))
                {
                    throw new UserException($"Restoran sa: {request.RestoranId} id-em ne postoji. Ukoliko je korisnik dostavljac/radnik restorana, " +
                        $"molimo da dodijelite restoran u kojem radi, ukoliko je kupac, molimo da setujete vrijednost na null");
                }

            }

        }

        public void ValidateKorisniciUpd(KorisniciUpdateRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Ime))
            {
                throw new UserException("Molimo unesite ime.");
            }

            if (string.IsNullOrWhiteSpace(request.Prezime))
            {
                throw new UserException("Molimo unesite prezime.");

            }

            if (string.IsNullOrWhiteSpace(request.Email))
            {
                throw new UserException("Molimo unesite email.");

            }

            if (string.IsNullOrWhiteSpace(request.Telefon))
            {
                throw new UserException("Molimo unesite broj telefona.");

            }
            
        }
    }
}
