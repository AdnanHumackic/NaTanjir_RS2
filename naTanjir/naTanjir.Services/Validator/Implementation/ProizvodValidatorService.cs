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
    public class ProizvodValidatorService : BaseValidatorService<Database.Proizvod>, IProizvodValidatorService
    {
        private readonly NaTanjirContext Context;

        public ProizvodValidatorService(NaTanjirContext context) : base(context)
        {
            this.Context = context;
        }

        public void ValidateProizvodIns(ProizvodiInsertRequest request)
        { 
            if (string.IsNullOrWhiteSpace(request.Opis))
            {
                throw new UserException("Molimo unesite opis proizvoda.");
            }

            if (request?.Cijena == null || request.Cijena <= 0)
            {
                throw new UserException("Molimo unesite validnu cijenu.");
            }
            var vrstaProizvoda = Context.VrstaProizvoda.Where(x => x.VrstaId == request.VrstaProizvodaId).FirstOrDefault();

            if (vrstaProizvoda == null)
            {
                throw new UserException($"Vrsta restorana sa id: {request.VrstaProizvodaId} ne postoji.");
            }

            var rest = Context.Restorans.Where(x => x.RestoranId == request.RestoranId).FirstOrDefault();

            if (rest == null)
            {
                throw new UserException($"Restoran sa id: {request.RestoranId} ne postoji.");

            }
        }

        public void ValidateProizvodUpd(ProizvodiUpdateRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Naziv))
            {
                throw new UserException("Molimo unesite naziv proizvoda.");
            }

            if (string.IsNullOrWhiteSpace(request.Opis))
            {
                throw new UserException("Molimo unesite opis proizvoda.");
            }

            if (request.Cijena == 0 || request.Cijena < 0)
            {
                throw new UserException("Molimo unesite validnu cijenu.");
            }
            var vrstaProizvoda = Context.VrstaProizvoda.Where(x => x.VrstaId == request.VrstaProizvodaId).FirstOrDefault();

            if (vrstaProizvoda == null)
            {
                throw new UserException($"Vrsta restorana sa id: {request.VrstaProizvodaId} ne postoji.");
            }

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite status restorana.");
            }
        }
    }
}
