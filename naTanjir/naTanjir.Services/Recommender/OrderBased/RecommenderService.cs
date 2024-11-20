using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using naTanjir.Model;
using naTanjir.Model.Exceptions;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Recommender.OrderBased
{
    public class RecommenderService : IRecommenderService
    {
        private readonly IMapper mapper;
        private readonly NaTanjirContext naTanjirContext;
        private static MLContext mlContext = null;
        private static object isLocked = new object();
        private static ITransformer model = null;

        private const string ModelFilePath = "order-model.zip";

        public RecommenderService(NaTanjirContext naTanjirContext, IMapper mapper)
        {
            this.naTanjirContext = naTanjirContext;
            this.mapper = mapper;
        }
        public async Task<List<Model.Proizvod>> GetRecommendedProducts(int proizvodId)
        {
            bool proizvodExistsInOrders = naTanjirContext.StavkeNarudzbes
                .Any(x => x.ProizvodId == proizvodId);

            if (!proizvodExistsInOrders)
            {
                return null;
            }

            if (mlContext == null)
            {
                lock (isLocked)
                {
                    mlContext = new MLContext();

                    if (File.Exists(ModelFilePath))
                    {
                        using (var stream = new FileStream(ModelFilePath, FileMode.Open, FileAccess.Read, FileShare.Read))
                        {
                            model = mlContext.Model.Load(stream, out var modelInputSchema);
                        }
                    }
                    else
                    {
                        TrainData();
                    }
                }
            }

            var products = naTanjirContext.Proizvods.Where(x => x.ProizvodId != proizvodId);

            var predictionResult = new List<(Database.Proizvod, float)>();

            foreach (var product in products)
            {
                var predictionengine = mlContext.Model.CreatePredictionEngine<ProizvodEntry, Copurchase_prediction>(model);
                var prediction = predictionengine.Predict(
                                         new ProizvodEntry()
                                         {
                                             ProizvodId = (uint)proizvodId,
                                             CoPurchaseProizvodId = (uint)product.ProizvodId
                                         });

                predictionResult.Add(new(product, prediction.Score));
            }

            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

            return mapper.Map<List<Model.Proizvod>>(finalResult);
        }

        public void TrainData()
        {
            if (mlContext == null)
                mlContext = new MLContext();

            var allProductsQuery = naTanjirContext.Proizvods;
            var allProducts = allProductsQuery.ToList();

            var data = new List<ProizvodEntry>();

            foreach (var item in allProducts)
            {
                foreach (var rb in allProducts)
                {
                    if (rb.ProizvodId == item.ProizvodId)
                        continue;

                    data.Add(new ProizvodEntry()
                    {
                        ProizvodId = (uint)item.ProizvodId,
                        CoPurchaseProizvodId = (uint)rb.ProizvodId,
                    });
                }
            }

            var traindata = mlContext.Data.LoadFromEnumerable(data);

            MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options
            {
                MatrixColumnIndexColumnName = nameof(ProizvodEntry.ProizvodId),
                MatrixRowIndexColumnName = nameof(ProizvodEntry.CoPurchaseProizvodId),
                LabelColumnName = "Label",
                LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                Alpha = 0.01,
                Lambda = 0.005,
                // For better results use the following parameters
                NumberOfIterations = 100,
                C = 0.00001,
            };

            var estimator = mlContext.Recommendation().Trainers.MatrixFactorization(options);
            model = estimator.Fit(traindata);

            using (var stream = new FileStream(ModelFilePath, FileMode.Create, FileAccess.Write, FileShare.Write))
            {
                mlContext.Model.Save(model, traindata.Schema, stream);
            }
        }

    }
    public class Copurchase_prediction
    {
        public float Score { get; set; }
    }

    public class ProizvodEntry
    {
        [KeyType(count: 262111)]
        public uint ProizvodId { get; set; }

        [KeyType(count: 262111)]
        public uint CoPurchaseProizvodId { get; set; }

        public float Label { get; set; }
    }
}
