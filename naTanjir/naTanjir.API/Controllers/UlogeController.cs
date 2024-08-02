using Microsoft.AspNetCore.Mvc;
using naTanjir.Model;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UlogeController : BaseCRUDController<Model.Uloge, UlogeSearchObject, UlogeInsertRequest, UlogeUpdateRequest>
    {
        protected IUlogeService _service;

        public UlogeController(IUlogeService service)
            : base(service)
        {
        }
    }
}
