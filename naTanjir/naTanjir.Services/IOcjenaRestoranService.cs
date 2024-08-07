using naTanjir.Model;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.BaseServices.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public interface IOcjenaRestoranService:ICRUDService<OcjenaRestoran, OcjenaRestoranSearchObject, OcjenaRestoranInsertRequest, OcjenaRestoranUpdateRequest>
    {

    }
}
