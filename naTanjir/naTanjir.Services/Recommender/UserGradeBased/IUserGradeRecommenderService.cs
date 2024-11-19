using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Recommender.UserGradeBased
{
    public interface IUserGradeRecommenderService
    {
        Task<List<Model.Proizvod>> GetRecommendedGradedProducts(int korisnikId, int restoranId);
        void TrainData();
    }
}
