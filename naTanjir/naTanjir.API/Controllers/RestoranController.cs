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
    public class RestoranController:BaseCRUDControllerAsync<Model.Restoran, RestoranSearchObject, RestoranInsertRequest, RestoranUpdateRequest>
    {
        public RestoranController(IRestoranService service)
            : base(service)
        {
        }
        
        [AllowAnonymous]
        public override Task<PagedResult<Restoran>> GetList([FromQuery] RestoranSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        public override Task<Restoran> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Admin")]
        public override Task<Restoran> Insert(RestoranInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }
       
        [Authorize(Roles = "Vlasnik")]
        public override Task<Restoran> Update(int id, RestoranUpdateRequest request, CancellationToken cancellationToken = default)
        {
            return base.Update(id, request, cancellationToken);
        }
        
        [Authorize(Roles = "Vlasnik, Admin")]
        public override Task Delete(int id, CancellationToken cancellationToken = default)
        {
            return base.Delete(id, cancellationToken);
        }
    }
}
