using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Validator
{
    public interface IBaseValidatorService<TDbEntity> where TDbEntity:class
    {
        bool EntityExists(int id);
    }
}
