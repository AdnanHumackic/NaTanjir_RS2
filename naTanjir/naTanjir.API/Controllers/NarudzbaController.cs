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

        [Authorize(Roles = "Dostavljac")]
        [HttpPut("{id}/preuzmi/{dostavljacId}")]
        public async Task<Model.Narudzba> Preuzmi(int id,int dostavljacId, CancellationToken cancellationToken = default)
        {
            return await (_service as INarudzbaService).PreuzmiAsync(id, dostavljacId, cancellationToken);
        }

        [Authorize(Roles = "Dostavljac")]
        [HttpPut("{id}/uToku")]
        public async Task<Model.Narudzba> UToku(int id, CancellationToken cancellationToken = default)
        {
            return await (_service as INarudzbaService).UTokuAsync(id, cancellationToken);
        }

        [Authorize(Roles = "Kupac")]
        [HttpPut("{id}/ponisti")]
        public async Task<Model.Narudzba> Ponisti(int id, CancellationToken cancellationToken = default)
        {
            return await (_service as INarudzbaService).PonistiAsync(id, cancellationToken);
        }

        [Authorize(Roles = "Dostavljac")]
        [HttpPut("{id}/zavrsi")]
        public async Task<Model.Narudzba> Zavrsi(int id, CancellationToken cancellationToken = default)
        {
            return await (_service as INarudzbaService).ZavrsiAsync(id, cancellationToken);
        }

        [AllowAnonymous]
        [HttpGet("{id}/allowedActions")]
        public Task<List<string>> AllowedActions(int id, CancellationToken cancellationToken = default)
        {
            return (_service as INarudzbaService).AllowedActions(id, cancellationToken);
        }

        [AllowAnonymous]
        public override Task<PagedResult<Narudzba>> GetList([FromQuery] NarudzbaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        public override Task<Narudzba> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Kupac")]
        public override Task<Narudzba> Insert(NarudzbaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Kupac")]
        public override Task<Narudzba> Update(int id, NarudzbaUpdateRequest request, CancellationToken cancellationToken = default)
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
