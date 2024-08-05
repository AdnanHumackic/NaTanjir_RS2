using Microsoft.EntityFrameworkCore;
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
    public class UlogeValidatorService : BaseValidatorService<Database.Uloge>, IUlogeValidatorService
    {
        private readonly NaTanjirContext Context;

        public UlogeValidatorService(NaTanjirContext context):base(context)
        {
            this.Context = context;
        }

        public void ValidateUlogaNazivIns(UlogeInsertRequest request)
        {
            Validate(request.Naziv);
        }

        public void ValidateUlogaNazivUpd(UlogeUpdateRequest request)
        {
            Validate(request.Naziv);
        }

        private void Validate(string naziv)
        {
            if (string.IsNullOrWhiteSpace(naziv))
            {
                throw new UserException("Molimo unesite naziv uloge");
            }

            var obj = Context.Uloges.Where(x => x.Naziv == naziv).FirstOrDefault();

            if (obj != null)
            {
                throw new UserException($"{obj.Naziv} već postoji.");
            }
        }
    }
}
