using Microsoft.AspNetCore.Mvc;
using naTanjir.API.Controllers.BaseControllers;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class LokacijaController : BaseCRUDControllerAsync<Model.Lokacija, LokacijaSearchObject, LokacijaInsertRequest, LokacijaUpdateRequest>
    {
        public LokacijaController(ILokacijaService service)
            : base(service)
        {
        }
    }
}
