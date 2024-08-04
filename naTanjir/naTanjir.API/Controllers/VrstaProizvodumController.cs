using Microsoft.AspNetCore.Mvc;
using naTanjir.Model.SearchObject;
using naTanjir.Model;
using naTanjir.Services;
using naTanjir.Model.Request;
using Microsoft.AspNetCore.Authorization;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VrstaProizvodumController : BaseCRUDController<Model.VrstaProizvodum, VrstaProizvodumSearchObject, VrstaProizvodumInsertRequest, VrstaProizvodumUpdateRequest>
    {
        public VrstaProizvodumController(IVrstaProizvodumService service)
            : base(service)
        {
        }

        [AllowAnonymous]
        public override PagedResult<VrstaProizvodum> GetList([FromQuery] VrstaProizvodumSearchObject search)
        {
            return base.GetList(search);
        }

        [AllowAnonymous]
        public override VrstaProizvodum GetById(int id)
        {
            return base.GetById(id);
        }

        //[Authorize(Roles = "Admin")]
        public override VrstaProizvodum Insert(VrstaProizvodumInsertRequest request)
        {
            return base.Insert(request);
        }

        //[Authorize(Roles = "Admin")]
        public override VrstaProizvodum Update(int id, VrstaProizvodumUpdateRequest request)
        {
            return base.Update(id, request);
        }

        //[Authorize(Roles = "Admin")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }
    }
}
