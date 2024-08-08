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
    public class UlogeController : BaseCRUDControllerAsync<Model.Uloge, UlogeSearchObject, UlogeInsertRequest, UlogeUpdateRequest>
    {
        public UlogeController(IUlogeService service)
            : base(service)
        {
        }

        [AllowAnonymous]
        public override Task<PagedResult<Uloge>> GetList([FromQuery] UlogeSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        public override Task<Uloge> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        //[Authorize(Roles = "Admin")]
        public override Task<Uloge> Insert(UlogeInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        //[Authorize(Roles = "Admin")]
        public override Task<Uloge> Update(int id, UlogeUpdateRequest request, CancellationToken cancellationToken = default)
        {
            return base.Update(id, request, cancellationToken);
        }

        //[Authorize(Roles = "Admin")]
        public override Task Delete(int id, CancellationToken cancellationToken = default)
        {
            return base.Delete(id, cancellationToken);
        }
       
    }
}
