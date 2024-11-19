using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Storage;
using naTanjir.API.Controllers.BaseControllers;
using naTanjir.Model;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisniciController:BaseCRUDControllerAsync<Model.Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        public KorisniciController(IKorisniciService service)
            : base(service)
        {
        }

       [HttpPost("login")]
       [AllowAnonymous]
       public Model.Korisnici Login(string username, string password, string connectionId)
       {
           return (_service as IKorisniciService).Login(username, password, connectionId);
       }

        [AllowAnonymous]
        [HttpGet("{korisnikId}/{restoranId}/recommended")]
        public Task<List<Model.Proizvod>> Recommend(int korisnikId, int restoranId)
        {
            return (_service as IKorisniciService).GetRecommendedGradedProducts(korisnikId, restoranId);
        }
        [AllowAnonymous]
        [HttpGet("traindata")]
        public void TrainData()
        {
            (_service as IKorisniciService).TrainData();
        }
    }
}
