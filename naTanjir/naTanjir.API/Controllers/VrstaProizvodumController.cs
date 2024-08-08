using Microsoft.AspNetCore.Mvc;
using naTanjir.Model.SearchObject;
using naTanjir.Model;
using naTanjir.Services;
using naTanjir.Model.Request;
using Microsoft.AspNetCore.Authorization;
using naTanjir.API.Controllers.BaseControllers;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VrstaProizvodumController : BaseCRUDControllerAsync<Model.VrstaProizvodum, VrstaProizvodumSearchObject, VrstaProizvodumInsertRequest, VrstaProizvodumUpdateRequest>
    {
        public VrstaProizvodumController(IVrstaProizvodumService service)
            : base(service)
        {
        }

        [AllowAnonymous]
        public override Task<PagedResult<VrstaProizvodum>> GetList([FromQuery] VrstaProizvodumSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        public override Task<VrstaProizvodum> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        //[Authorize(Roles = "Admin")]
        public override Task<VrstaProizvodum> Insert(VrstaProizvodumInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        //[Authorize(Roles = "Admin")]
        public override Task<VrstaProizvodum> Update(int id, VrstaProizvodumUpdateRequest request, CancellationToken cancellationToken = default)
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
