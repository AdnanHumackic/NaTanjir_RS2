using Microsoft.AspNetCore.Mvc;
using naTanjir.Model;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProizvodKorpaController : BaseCRUDController<Model.ProizvodKorpa, ProizvodKorpaSearchObject, ProizvodKorpaInsertRequest, ProizvodKorpaUpdateRequest>
    {
        public ProizvodKorpaController(IProizvodKorpaService service)
            : base(service)
        {
        }
    }
}
