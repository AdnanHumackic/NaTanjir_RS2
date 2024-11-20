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
    public class OcjenaProizvodController:BaseCRUDControllerAsync<Model.OcjenaProizvod, OcjenaProizvodSearchObject, OcjenaProizvodInsertRequest, OcjenaProizvodUpdateRequest>
    {
        public OcjenaProizvodController(IOcjenaProizvodService service)
            : base(service)
        {
        }

        [AllowAnonymous]
        public override Task<PagedResult<OcjenaProizvod>> GetList([FromQuery] OcjenaProizvodSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        public override Task<OcjenaProizvod> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Kupac")]
        public override Task<OcjenaProizvod> Insert(OcjenaProizvodInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Kupac")]
        public override Task<OcjenaProizvod> Update(int id, OcjenaProizvodUpdateRequest request, CancellationToken cancellationToken = default)
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
