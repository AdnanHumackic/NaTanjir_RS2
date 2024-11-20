using naTanjir.Model.Request;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Validator.Interfaces
{
    public interface IProizvodValidatorService : IBaseValidatorService<Database.Proizvod>
    {
        void ValidateProizvodIns(ProizvodiInsertRequest request);
        void ValidateProizvodUpd(ProizvodiUpdateRequest request);
    }
}
