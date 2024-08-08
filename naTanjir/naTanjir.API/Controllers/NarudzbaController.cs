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
    public class NarudzbaController:BaseCRUDControllerAsync<Model.Narudzba, NarudzbaSearchObject, NarudzbaInsertRequest, NarudzbaUpdateRequest>
    {
        public NarudzbaController(INarudzbaService service)
            : base(service)
        {
        }
    }
}
