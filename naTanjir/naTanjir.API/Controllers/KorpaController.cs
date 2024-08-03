using Microsoft.AspNetCore.Mvc;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorpaController:BaseCRUDController<Model.Korpa, KorpaSearchObject, KorpaInsertRequest, KorpaUpdateRequest>
    {
        public KorpaController(IKorpaService service)
            : base(service)
        {
        }
    }
}
