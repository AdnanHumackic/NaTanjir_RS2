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
    public class OcjenaRestoranController:BaseCRUDControllerAsync<Model.OcjenaRestoran, OcjenaRestoranSearchObject, OcjenaRestoranInsertRequest, OcjenaRestoranUpdateRequest>
    {
        public OcjenaRestoranController(IOcjenaRestoranService service)
            : base(service)
        {
        }

        [AllowAnonymous]
        public override Task<PagedResult<OcjenaRestoran>> GetList([FromQuery] OcjenaRestoranSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }
        
        [AllowAnonymous]
        public override Task<OcjenaRestoran> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Kupac")]
        public override Task<OcjenaRestoran> Insert(OcjenaRestoranInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Kupac")]
        public override Task<OcjenaRestoran> Update(int id, OcjenaRestoranUpdateRequest request, CancellationToken cancellationToken = default)
        {
            return base.Update(id, request, cancellationToken);
        }

        [Authorize(Roles = "Kupac")]
        public override Task Delete(int id, CancellationToken cancellationToken = default)
        {
            return base.Delete(id, cancellationToken);
        }
    }
}
