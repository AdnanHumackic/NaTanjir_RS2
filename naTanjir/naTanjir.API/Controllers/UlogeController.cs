using Microsoft.AspNetCore.Authorization;
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
        public UlogeController(IUlogeService service)
            : base(service)
        {
        }

        [AllowAnonymous]
        public override PagedResult<Uloge> GetList([FromQuery] UlogeSearchObject search)
        {
            return base.GetList(search);
        }

        [AllowAnonymous]
        public override Uloge GetById(int id)
        {
            return base.GetById(id);
        }

        [Authorize(Roles = "Admin")]
        public override Uloge Insert(UlogeInsertRequest request)
        {
            return base.Insert(request);
        }

        [Authorize(Roles = "Admin")]
        public override Uloge Update(int id, UlogeUpdateRequest request)
        {
            return base.Update(id, request);
        }

        [Authorize(Roles = "Admin")]
        public override void Delete(int id)
        {
            base.Delete(id);
        }
    }
}
