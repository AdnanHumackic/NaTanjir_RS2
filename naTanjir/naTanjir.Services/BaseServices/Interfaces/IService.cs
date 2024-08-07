using naTanjir.Model;
using naTanjir.Model.SearchObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.BaseServices.Interfaces
{
    public interface IService<TModel, TSearch> where TSearch : BaseSearchObject
    {
        public PagedResult<TModel> GetPaged(TSearch search);

        public TModel GetById(int id);
    }
}
