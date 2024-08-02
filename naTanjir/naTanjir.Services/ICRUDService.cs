using Microsoft.EntityFrameworkCore.Metadata.Internal;
using naTanjir.Model.SearchObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public interface ICRUDService<TModel, TSearch, TInsert, TUpdate>:IService<TModel, TSearch> where TModel:class where TSearch : BaseSearchObject
    {
        TModel Insert(TInsert model);

        TModel Update(int id, TUpdate request);
        void Delete(int id);

    }
}
