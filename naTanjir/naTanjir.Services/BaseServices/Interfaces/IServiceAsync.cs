using naTanjir.Model;
using naTanjir.Model.SearchObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.BaseServices.Interfaces
{
    public interface IServiceAsync<TModel, TSearch> where TSearch:BaseSearchObject
    {
        public Task<PagedResult<TModel>> GetPagedAsync(TSearch search, CancellationToken cancellationToken = default);
        public Task<TModel> GetByIdAsync(int id, CancellationToken cancellationToken = default);
    }
}
