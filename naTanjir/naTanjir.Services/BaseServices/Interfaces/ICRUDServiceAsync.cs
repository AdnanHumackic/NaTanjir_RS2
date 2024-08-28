﻿using naTanjir.Model.SearchObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.BaseServices.Interfaces
{
    public interface ICRUDServiceAsync<TModel, TSearch, TInsert, TUpdate> : IServiceAsync<TModel, TSearch> where TModel : class where TSearch : BaseSearchObject
    {
        Task<TModel> InsertAsync(TInsert request, CancellationToken cancellationToken = default);

        Task<TModel> UpdateAsync(int id, TUpdate request, CancellationToken cancellationToken = default);
        Task DeleteAsync(int id, CancellationToken cancellationToken = default);
    }
}