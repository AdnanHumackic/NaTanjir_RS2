using Microsoft.AspNetCore.Mvc;
using naTanjir.Model.SearchObject;
using naTanjir.Model;
using naTanjir.Services;
using naTanjir.Model.Request;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VrstaProizvodumController : BaseCRUDController<Model.VrstaProizvodum, VrstaProizvodumSearchObject, VrstaProizvodumInsertRequest, VrstaProizvodumUpdateRequest>
    {
        protected IVrstaProizvodumService _service;

        public VrstaProizvodumController(IVrstaProizvodumService service)
            : base(service)
        {
        }
    }
}
