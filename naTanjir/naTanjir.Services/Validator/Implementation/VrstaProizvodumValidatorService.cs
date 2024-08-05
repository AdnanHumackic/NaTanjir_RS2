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
    public class VrstaProizvodumValidatorService : BaseValidatorService<Database.VrstaProizvodum>, IVrstaProizvodumValidatorService
    {
        private readonly NaTanjirContext Context;

        public VrstaProizvodumValidatorService(NaTanjirContext context) : base(context)
        {
            this.Context = context;
        }

        public void ValidateVrstaProizvodumNazivIns(VrstaProizvodumInsertRequest request)
        {
            Validate(request.Naziv);
        }

        public void ValidateVrstaProizvodumNazivUpd(VrstaProizvodumUpdateRequest request)
        {
            Validate(request.Naziv);
        }

        private void Validate(string naziv)
        {
            if (string.IsNullOrWhiteSpace(naziv))
            {
                throw new UserException("Molimo unesite naziv vrste proizvoda.");
            }

            var obj = Context.VrstaProizvoda.Where(x => x.Naziv == naziv).FirstOrDefault();

            if (obj != null)
            {
                throw new UserException($"{obj.Naziv} već postoji.");
            }
        }
    }
}
