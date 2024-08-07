using naTanjir.Model.SearchObject;
using naTanjir.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using naTanjir.Model.Request;
using naTanjir.Services.BaseServices.Interfaces;

namespace naTanjir.Services
{
    public interface IVrstaProizvodumService : ICRUDService<VrstaProizvodum, VrstaProizvodumSearchObject, VrstaProizvodumInsertRequest, VrstaProizvodumUpdateRequest>
    {

    }
}
