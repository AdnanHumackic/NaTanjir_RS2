using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using naTanjir.Model;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OcjenaRestoranController:BaseCRUDController<Model.OcjenaRestoran, OcjenaRestoranSearchObject, OcjenaRestoranInsertRequest, OcjenaRestoranUpdateRequest>
    {
        public OcjenaRestoranController(IOcjenaRestoranService service)
            : base(service)
        {
        }
    }
}
