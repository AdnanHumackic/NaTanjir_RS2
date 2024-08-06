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
    public class OcjenaRestoranValidatorService : BaseValidatorService<Database.OcjenaRestoran>, IOcjenaRestoranValidatorService
    {
        private readonly NaTanjirContext Context;

        public OcjenaRestoranValidatorService(NaTanjirContext context) : base(context)
        {
            this.Context = context;
        }

        public void ValidateOcjenaRestorantIns(OcjenaRestoranInsertRequest request)
        {
            var korisnik = Context.Korisnicis.Where(x => x.KorisnikId == request.KorisnikId).FirstOrDefault();

            if (korisnik == null)
            {
                throw new UserException($"Korisnik sa id: {request.KorisnikId} ne postoji.");
            }

            var rest = Context.Restorans.Where(x => x.RestoranId == request.RestoranId).FirstOrDefault();

            if (rest == null)
            {
                throw new UserException($"Restoran sa id: {request.RestoranId} ne postoji.");
            }

            var restOcj = Context.OcjenaRestorans.Where(x => x.RestoranId == request.RestoranId
            && x.KorisnikId == request.KorisnikId).FirstOrDefault();

            if (restOcj != null)
            {
                throw new UserException($"Restoran sa id: {request.RestoranId} je već ocijenjen od strane korisnika sa id: {request.KorisnikId}.");
            }
        }
    }
}
