using Microsoft.AspNetCore.Mvc;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RestoranFavoritController:BaseCRUDController<Model.RestoranFavorit, RestoranFavoritSearchObject, RestoranFavoritInsertRequest, RestoranFavoritUpdateRequest>
    {
        public RestoranFavoritController(IRestoranFavoritService service)
            : base(service)
        {
        }
    }
}
