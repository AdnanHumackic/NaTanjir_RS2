using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public interface IRestoranFavoritService:ICRUDService<Model.RestoranFavorit, RestoranFavoritSearchObject, RestoranFavoritInsertRequest, RestoranFavoritUpdateRequest>
    {
    }
}
