using naTanjir.Model.Request;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Validator.Interfaces
{
    public interface IUlogeValidatorService : IBaseValidatorService<Database.Uloge>
    {
        void ValidateUlogaNazivIns(UlogeInsertRequest request);
        void ValidateUlogaNazivUpd(UlogeUpdateRequest request);
    }
}
