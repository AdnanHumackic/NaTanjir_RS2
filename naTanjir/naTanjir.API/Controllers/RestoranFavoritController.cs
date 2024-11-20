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
    public class RestoranFavoritController:BaseCRUDControllerAsync<Model.RestoranFavorit, RestoranFavoritSearchObject, RestoranFavoritInsertRequest, RestoranFavoritUpdateRequest>
    {
        public RestoranFavoritController(IRestoranFavoritService service)
            : base(service)
        {
        }

        [AllowAnonymous]
        public override Task<PagedResult<RestoranFavorit>> GetList([FromQuery] RestoranFavoritSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        public override Task<RestoranFavorit> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Kupac")]
        public override Task<RestoranFavorit> Insert(RestoranFavoritInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Kupac")]
        public override Task<RestoranFavorit> Update(int id, RestoranFavoritUpdateRequest request, CancellationToken cancellationToken = default)
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
