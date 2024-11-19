using naTanjir.Model;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.BaseServices.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public interface IKorisniciService:ICRUDServiceAsync<Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        Model.Korisnici Login(string username, string password, string connectionId);

        Task<List<Model.Proizvod>> GetRecommendedGradedProducts(int korisnikId, int restoranId);
        void TrainData();
    }
}
