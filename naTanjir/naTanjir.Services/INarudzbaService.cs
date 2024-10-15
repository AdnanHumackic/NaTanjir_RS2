using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.BaseServices.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public interface INarudzbaService:ICRUDServiceAsync<Model.Narudzba, NarudzbaSearchObject, NarudzbaInsertRequest, NarudzbaUpdateRequest>
    {
        Task<Model.Narudzba> PreuzmiAsync(int narudzbaId, CancellationToken cancellationToken = default);
        Task<Model.Narudzba> UTokuAsync(int narudzbaId, CancellationToken cancellationToken = default);
        Task<Model.Narudzba> ZavrsiAsync(int narudzbaId, CancellationToken cancellationToken = default);

        Task<Model.Narudzba> PonistiAsync(int narudzbaId, CancellationToken cancellationToken = default);

        Task<List<string>> AllowedActions(int narudzbaId, CancellationToken cancellationToken = default);
    }
}
