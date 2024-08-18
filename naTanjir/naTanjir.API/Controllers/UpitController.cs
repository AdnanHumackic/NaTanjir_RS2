using Microsoft.AspNetCore.Mvc;
using naTanjir.API.Controllers.BaseControllers;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UpitController:BaseCRUDControllerAsync<Model.Upit, UpitSearchObject, UpitInsertRequest, UpitUpdateRequest>
    {
        public UpitController(IUpitService service)
           : base(service)
        {
        }
    }
}
