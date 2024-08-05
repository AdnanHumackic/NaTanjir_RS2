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
    public class RestoranFavoritValidatorService : BaseValidatorService<Database.RestoranFavorit>, IRestoranFavoritValidatorService
    {
        private readonly NaTanjirContext Context;

        public RestoranFavoritValidatorService(NaTanjirContext context) : base(context)
        {
            this.Context = context;
        }

        public void ValidateRestoranFavoritIns(RestoranFavoritInsertRequest request)
        {
            var objKor = Context.Korisnicis
                .Where(x => x.KorisnikId == request.KorisnikId)
                .FirstOrDefault();

            var objRest = Context.Restorans
                .Where(x => x.RestoranId == request.RestoranId)
                .FirstOrDefault();

            if (objKor == null)
            {
                throw new UserException($"Korisnik sa id: {request.KorisnikId} ne postoji.");
            }

            if (objRest == null)
            {
                throw new UserException($"Restoran sa id: {request.RestoranId} ne postoji.");
            }


            var favoritExists = Context.RestoranFavorits
                .Where(x => x.RestoranId == request.RestoranId && x.KorisnikId == request.KorisnikId)
                .FirstOrDefault();

            if (favoritExists != null)
            {
                throw new UserException($"Restoran sa id: {request.RestoranId} je već označen kao favorit za korisnika sa id: {request.KorisnikId}.");
            }
        }
    }
}
