using Microsoft.AspNetCore.Mvc;
using naTanjir.Model;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisniciUlogeController:BaseCRUDController<Model.KorisniciUloge, KorisniciUlogeSearchObject, KorisniciUlogeInsertRequest, KorisniciUlogeUpdateRequest>
    {
        public KorisniciUlogeController(IKorisniciUloge service)
            : base(service)
        {
        }
        
    }
}
