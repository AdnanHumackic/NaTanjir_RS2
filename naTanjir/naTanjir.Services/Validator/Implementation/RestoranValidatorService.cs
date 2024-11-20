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
            var nazivRest = Context.Restorans.Where(x => x.Naziv.ToLower() == request.Naziv.ToLower()).FirstOrDefault();

            if (nazivRest != null)
            {
                throw new UserException($"Restoran sa nazivom: {request.Naziv} već postoji.");
            }

            if (string.IsNullOrWhiteSpace(request.RadnoVrijemeOd))
            {
                throw new UserException("Molimo unesite radno vrijeme od (npr 08:00).");
            }

            if (string.IsNullOrWhiteSpace(request.RadnoVrijemeDo))
            {
                throw new UserException("Molimo unesite radno vrijeme do (npr 20:00).");
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

            if (string.IsNullOrWhiteSpace(request.Lokacija))
            {
                throw new UserException($"Molimo unesite lokaciju restorana.");

            }
        }

        public void ValidateRestoranUpd(RestoranUpdateRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.RadnoVrijemeOd))
            {
                throw new UserException("Molimo unesite radno vrijeme od.");
            }

            if (string.IsNullOrWhiteSpace(request.RadnoVrijemeDo))
            {
                throw new UserException("Molimo unesite radno vrijeme do.");
            }

            if (string.IsNullOrWhiteSpace(request.Lokacija))
            {
                throw new UserException("Molimo unesite lokaciju restorana.");
            }

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite status restorana.");
            }
        }
    }
}
