using Microsoft.AspNetCore.Mvc;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class NarudzbaController:BaseCRUDController<Model.Narudzba, NarudzbaSearchObject, NarudzbaInsertRequest, NarudzbaUpdateRequest>
    {
        protected INarudzbaService _service;

        public NarudzbaController(INarudzbaService service)
            : base(service)
        {
        }
    }
}
