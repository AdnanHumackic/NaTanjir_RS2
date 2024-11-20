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
    public class ProizvodiController : BaseCRUDControllerAsync<Model.Proizvod, ProizvodiSearchObject, ProizvodiInsertRequest, ProizvodiUpdateRequest>
    {
        public ProizvodiController(IProizvodiService service)
            : base(service)
        {
        }

        [AllowAnonymous]
        [HttpGet("{proizvodId}/recommended")]
        public Task<List<Model.Proizvod>> Recommend(int proizvodId)
        {
            return (_service as IProizvodiService).Recommend(proizvodId);
        }
        [AllowAnonymous]
        [HttpGet("traindata")]
        public void TrainData()
        {
            (_service as IProizvodiService).TrainData();
        }

        [AllowAnonymous]
        public override Task<PagedResult<Proizvod>> GetList([FromQuery] ProizvodiSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        public override Task<Proizvod> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Vlasnik")]
        public override Task<Proizvod> Insert(ProizvodiInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Vlasnik")]
        public override Task<Proizvod> Update(int id, ProizvodiUpdateRequest request, CancellationToken cancellationToken = default)
        {
            return base.Update(id, request, cancellationToken);
        }

        [Authorize(Roles = "Vlasnik")]
        public override Task Delete(int id, CancellationToken cancellationToken = default)
        {
            return base.Delete(id, cancellationToken);
        }
    }
}
