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
    public class OcjenaProizvodValidatorService : BaseValidatorService<Database.OcjenaProizvod>, IOcjenaProizvodValidatorService
    {
        private readonly NaTanjirContext Context;

        public OcjenaProizvodValidatorService(NaTanjirContext context) : base(context)
        {
            this.Context = context;
        }

        public void ValidateOcjenaProizvodtIns(OcjenaProizvodInsertRequest request)
        {
            var korisnik = Context.Korisnicis.Where(x => x.KorisnikId == request.KorisnikId).FirstOrDefault();

            if (korisnik == null)
            {
                throw new UserException($"Korisnik sa id: {request.KorisnikId} ne postoji.");
            }

            var rest = Context.Proizvods.Where(x => x.ProizvodId == request.ProizvodId).FirstOrDefault();

            if (rest == null)
            {
                throw new UserException($"Proizvod sa id: {request.ProizvodId} ne postoji.");
            }

            var restOcj = Context.OcjenaProizvods.Where(x => x.ProizvodId == request.ProizvodId
            && x.KorisnikId == request.KorisnikId).FirstOrDefault();

            if (restOcj != null)
            {
                throw new UserException($"Proizvod sa id: {request.ProizvodId} je već ocijenjen od strane korisnika sa id: {request.KorisnikId}.");
            }
        }
    }
}
