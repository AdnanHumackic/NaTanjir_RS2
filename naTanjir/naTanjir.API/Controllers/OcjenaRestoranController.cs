using Microsoft.AspNetCore.Mvc;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OcjenaRestoranController:BaseCRUDController<Model.OcjenaRestoran, OcjenaRestoranSearchObject, OcjenaRestoranInsertRequest, OcjenaRestoranUpdateRequest>
    {
        protected IOcjenaRestoranService _service;

        public OcjenaRestoranController(IOcjenaRestoranService service)
            : base(service)
        {
        }
    }
}
