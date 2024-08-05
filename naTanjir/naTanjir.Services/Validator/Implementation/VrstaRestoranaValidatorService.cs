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
    public class VrstaRestoranaValidatorService : BaseValidatorService<Database.VrstaRestorana>, IVrstaRestoranaValidatorService
    {
        private readonly NaTanjirContext Context;

        public VrstaRestoranaValidatorService(NaTanjirContext context) : base(context)
        {
            this.Context = context;
        }

        public void ValidateVrstaRestoranaNazivIns(VrstaRestoranaInsertRequest request)
        {
            Validate(request.Naziv);
        }

        public void ValidateVrstaRestoranaNazivUpd(VrstaRestoranaUpdateRequest request)
        {
            Validate(request.Naziv);
        }

        private void Validate(string naziv)
        {
            if (string.IsNullOrWhiteSpace(naziv))
            {
                throw new UserException("Molimo unesite naziv vrste restorana");
            }

            var obj = Context.VrstaRestoranas.Where(x => x.Naziv == naziv).FirstOrDefault();

            if (obj != null)
            {
                throw new UserException($"{obj.Naziv} već postoji.");
            }
        }
    }
}
