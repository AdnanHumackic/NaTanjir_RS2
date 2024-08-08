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
    public class VrstaRestoranaController : BaseCRUDControllerAsync<Model.VrstaRestorana, VrstaRestoranaSearchObject, VrstaRestoranaInsertRequest, VrstaRestoranaUpdateRequest>
    {
        public VrstaRestoranaController(IVrstaRestoranaService service)
            : base(service)
        {
        }

        [AllowAnonymous]
        public override Task<PagedResult<VrstaRestorana>> GetList([FromQuery] VrstaRestoranaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        //[AllowAnonymous]
        public override Task<VrstaRestorana> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        //[Authorize(Roles ="Admin")]
        public override Task<VrstaRestorana> Insert(VrstaRestoranaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }
        
        //[Authorize(Roles = "Admin")]
        public override Task<VrstaRestorana> Update(int id, VrstaRestoranaUpdateRequest request, CancellationToken cancellationToken = default)
        {
            return base.Update(id, request, cancellationToken);
        }
        //[Authorize(Roles = "Admin")]
        public override Task Delete(int id, CancellationToken cancellationToken = default)
        {
            return  base.Delete(id, cancellationToken);
        }
        
    }
}
