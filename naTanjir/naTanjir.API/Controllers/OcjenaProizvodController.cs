using Microsoft.AspNetCore.Mvc;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OcjenaProizvodController:BaseCRUDController<Model.OcjenaProizvod, OcjenaProizvodSearchObject, OcjenaProizvodInsertRequest, OcjenaProizvodUpdateRequest>
    {
        protected IOcjenaProizvodService _service;

        public OcjenaProizvodController(IOcjenaProizvodService service)
            : base(service)
        {
        }
    }
}
