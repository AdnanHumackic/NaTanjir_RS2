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

        [HttpPut("{id}/preuzmi")]
        public async Task<Model.Narudzba> Preuzmi(int id, CancellationToken cancellationToken = default)
        {
            return await (_service as INarudzbaService).PreuzmiAsync(id, cancellationToken);
        }

        [HttpPut("{id}/uToku")]
        public async Task<Model.Narudzba> UToku(int id, CancellationToken cancellationToken = default)
        {
            return await (_service as INarudzbaService).UTokuAsync(id, cancellationToken);
        }

        [HttpPut("{id}/ponisti")]
        public async Task<Model.Narudzba> Ponisti(int id, CancellationToken cancellationToken = default)
        {
            return await (_service as INarudzbaService).PonistiAsync(id, cancellationToken);
        }

        [HttpPut("{id}/zavrsi")]
        public async Task<Model.Narudzba> Zavrsi(int id, CancellationToken cancellationToken = default)
        {
            return await (_service as INarudzbaService).ZavrsiAsync(id, cancellationToken);
        }

        [HttpGet("{id}/allowedActions")]
        public Task<List<string>> AllowedActions(int id, CancellationToken cancellationToken = default)
        {
            return (_service as INarudzbaService).AllowedActions(id, cancellationToken);
        }
    }
}
