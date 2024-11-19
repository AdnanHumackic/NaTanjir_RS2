using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Recommender
{
    public interface IRecommenderService
    {
        Task<List<Model.Proizvod>> GetRecommendedProducts(int proizvodId);
        void TrainData();
    }
}
