using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using naTanjir.API.Controllers.BaseControllers;
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
        public VrstaRestoranaController(IVrstaRestoranaService service)
            : base(service)
        {
        }

        [AllowAnonymous]
        public override PagedResult<VrstaRestorana> GetList([FromQuery] VrstaRestoranaSearchObject search)
        {
            return base.GetList(search);
        }

        [AllowAnonymous]
        public override VrstaRestorana GetById(int id)
        {
            return base.GetById(id);
        }

        //[Authorize(Roles ="Admin")]
        public override VrstaRestorana Insert(VrstaRestoranaInsertRequest request)
        {
            return base.Insert(request);
        }

        //[Authorize(Roles = "Admin")]
        public override VrstaRestorana Update(int id, VrstaRestoranaUpdateRequest request)
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
