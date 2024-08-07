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
        public bool EntityExists(int id)
        {
            var entity = Context.Set<TDbEntity>().Find(id);

            if (entity == null)
            {
                throw new UserException($"Ne postoji {typeof(TDbEntity).Name} sa id: {id}");
            }
            return true;
        }
    }
}
