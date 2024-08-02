using Microsoft.AspNetCore.Mvc;
using naTanjir.Model;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VrstaRestoranaController : BaseCRUDController<Model.VrstaRestorana, VrstaRestoranaSearchObject, VrstaRestoranaInsertRequest, VrstaRestoranaUpdateRequest>
    {
        protected IVrstaRestoranaService _service;

        public VrstaRestoranaController(IVrstaRestoranaService service)
            : base(service)
        {
        }
    }
}
