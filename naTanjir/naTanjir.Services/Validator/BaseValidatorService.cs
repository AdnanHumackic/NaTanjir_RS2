using naTanjir.Model.Exceptions;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Validator
{
    public class BaseValidatorService<TDbEntity> : IBaseValidatorService<TDbEntity> where TDbEntity : class
    {
        private readonly NaTanjirContext Context;

        public BaseValidatorService(NaTanjirContext context)
        {
            this.Context = context;
        }
    }
}
