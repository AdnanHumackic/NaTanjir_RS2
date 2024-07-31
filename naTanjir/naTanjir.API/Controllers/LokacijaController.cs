using Microsoft.AspNetCore.Mvc;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class LokacijaController : BaseCRUDController<Model.Lokacija, LokacijaSearchObject, LokacijaInsertRequest, LokacijaUpdateRequest>
    {
        protected ILokacijaService _service;

        public LokacijaController(ILokacijaService service)
            : base(service)
        {
        }
    }
}
