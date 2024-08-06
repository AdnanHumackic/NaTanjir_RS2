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
    public class RestoranValidatorService : BaseValidatorService<Database.Restoran>, IRestoranValidatorService
    {
        private readonly NaTanjirContext Context;

        public RestoranValidatorService(NaTanjirContext context) : base(context)
        {
            this.Context = context;
        }

        public void ValidateRestoranIns(RestoranInsertRequest request)
        {
            var nazivRest = Context.Restorans.Where(x => x.Naziv == request.Naziv).FirstOrDefault();

            if (nazivRest != null)
            {
                throw new UserException($"Restoran sa nazivom: {request.Naziv} već postoji.");
            }

            var vrstaRest = Context.VrstaRestoranas.Where(x => x.VrstaId == request.VrstaRestoranaId).FirstOrDefault();

            if (vrstaRest == null)
            {
                throw new UserException($"Vrsta restorana sa id: {request.VrstaRestoranaId} ne postoji.");
            }

            var vlasnik = Context.Korisnicis.Where(x => x.KorisnikId == request.VlasnikId).FirstOrDefault();

            if (vlasnik == null)
            {
                throw new UserException($"Korisnik sa id: {request.VlasnikId} ne postoji.");
            }
        }
    }
}
