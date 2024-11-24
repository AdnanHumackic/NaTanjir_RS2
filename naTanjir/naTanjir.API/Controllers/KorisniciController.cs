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

       [AllowAnonymous]
       [HttpPost("login")]
       public Model.Korisnici Login(string username, string password, string connectionId)
       {
           return (_service as IKorisniciService).Login(username, password, connectionId);
       }

        [Authorize(Roles = "Kupac")]
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

        [AllowAnonymous]
        public override Task<PagedResult<Korisnici>> GetList([FromQuery] KorisniciSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        public override Task<Korisnici> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [AllowAnonymous]
        public override Task<Korisnici> Insert(KorisniciInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Kupac,Vlasnik,Admin,Dostavljac,RadnikRestorana")]
        public override Task<Korisnici> Update(int id, KorisniciUpdateRequest request, CancellationToken cancellationToken = default)
        {
            return base.Update(id, request, cancellationToken);
        }

        [Authorize(Roles = "Vlasnik,Admin")]
        public override Task Delete(int id, CancellationToken cancellationToken = default)
        {
            return base.Delete(id, cancellationToken);
        }
    }
}
