using naTanjir.Model.Request;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Validator.Interfaces
{
    public interface IOcjenaProizvodValidatorService:IBaseValidatorService<Database.OcjenaProizvod>
    {
        void ValidateOcjenaProizvodtIns(OcjenaProizvodInsertRequest request);

    }
}
