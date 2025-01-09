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
    public class LokacijaController : BaseCRUDControllerAsync<Model.Lokacija, LokacijaSearchObject, LokacijaInsertRequest, LokacijaUpdateRequest>
    {
        public LokacijaController(ILokacijaService service)
            : base(service)
        {
        }


        [Authorize(Roles = "Kupac, Dostavljac")]
        public override Task<PagedResult<Lokacija>> GetList([FromQuery] LokacijaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        public override Task<Lokacija> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Kupac, Dostavljac")]

        public override Task<Lokacija> Insert(LokacijaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Kupac, Dostavljac")]
        public override Task<Lokacija> Update(int id, LokacijaUpdateRequest request, CancellationToken cancellationToken = default)
        {
            return base.Update(id, request, cancellationToken);
        }

        [Authorize(Roles = "Kupac, Dostavljac")]
        public override Task Delete(int id, CancellationToken cancellationToken = default)
        {
            return base.Delete(id, cancellationToken);
        }
    }
}
