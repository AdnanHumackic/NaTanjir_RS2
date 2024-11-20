using naTanjir.Model.Request;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Validator.Interfaces
{
    public interface IRestoranValidatorService:IBaseValidatorService<Database.Restoran>
    {
        void ValidateRestoranIns(RestoranInsertRequest request);
        void ValidateRestoranUpd(RestoranUpdateRequest request);

    }
}
