using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using naTanjir.Model;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Recommender.UserGradeBased
{
    public class UserGradeRecommenderService : IUserGradeRecommenderService
    {
        private readonly IMapper mapper;
        private readonly NaTanjirContext naTanjirContext;
        public List<int> allProducts { get; set; }
        public List<int> allProductTypes { get; set; }
        public UserGradeRecommenderService(IMapper mapper, NaTanjirContext naTanjirContext)
        {
            this.mapper = mapper;
            this.naTanjirContext = naTanjirContext;
        }

        static MLContext mlContext = null;
        static object isLocked = new object();
        private const string ModelPath = "grade-model.zip";
        static ITransformer model = null;

        public async Task<List<Model.Proizvod>> GetRecommendedGradedProducts(int korisnikId, int restoranId)
        {
            if (model == null)
            {
                await LoadAllData();

                lock (isLocked)
                {
                    mlContext = new MLContext();

                    if (File.Exists(ModelPath))
                    {
                        using (var stream = new FileStream(ModelPath, FileMode.Open, FileAccess.Read, FileShare.Read))
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

            var gradedProducts=naTanjirContext
                .OcjenaProizvods
                .Where(x => x.KorisnikId == korisnikId && x.Proizvod.RestoranId==restoranId)
                .Select(x => x.ProizvodId)
                .Distinct()
                .ToList();

            var proizvodi = naTanjirContext
                .Proizvods
                .Where(p => p.RestoranId == restoranId)
                .ToList();

            var predictionResult = new List<(Database.Proizvod, float)>();

            foreach (var pr in proizvodi)
            {
                var predictionengine = mlContext.Model.CreatePredictionEngine<ProizvodEntry, Copurchase_prediction>(model);

                foreach (var ocjProizvod in gradedProducts)
                {
                    if (ocjProizvod == pr.ProizvodId)
                        continue;

                    var prediction = predictionengine.Predict(
                                         new ProizvodEntry()
                                         {
                                             ProizvodId = (uint)ocjProizvod,
                                             CoSimilarProizvodId = (uint)pr.ProizvodId
                                         });
                    predictionResult.Add(new(pr, prediction.Score));
                }
            }

            var finalResult = predictionResult
                .OrderByDescending(x => x.Item2)
                .Select(x => x.Item1)
                .Distinct()
                .Where(x => !gradedProducts.Any(y => x.ProizvodId == y))
                .Take(3)
                .ToList();

            var products = naTanjirContext
                .Proizvods
                .Include(x => x.VrstaProizvoda);

            var lista = new List<Model.Proizvod>();

            foreach (var k in finalResult)
            {
                var prod = await products.FirstOrDefaultAsync(x => x.ProizvodId == k.ProizvodId);
                if (prod != null)
                    lista.Add(mapper.Map<Model.Proizvod>(prod));
            }
            return lista;
        }
        private async Task LoadAllData()
        {
            allProducts = naTanjirContext.Proizvods.Select(x => x.ProizvodId).ToList();
            allProductTypes = naTanjirContext.VrstaProizvoda.Select(x => x.VrstaId).ToList();
        }
        public double ComputeCosineSimilarity(Database.Proizvod proizvod1, Database.Proizvod proizvod2)
        {
            var features1 = GetFeatureVector(proizvod1);
            var features2 = GetFeatureVector(proizvod2);

            double dotProduct = features1.Zip(features2, (f1, f2) => f1 * f2).Sum();
            double magnitude1 = Math.Sqrt(features1.Sum(f => f * f));
            double magnitude2 = Math.Sqrt(features2.Sum(f => f * f));
            if (magnitude1 == 0 || magnitude2 == 0)
                return 0;
            return dotProduct / (magnitude1 * magnitude2);
        }
        public double[] GetFeatureVector(Database.Proizvod proizvod)
        {
            var featureVector = new List<double>();

            allProducts = naTanjirContext.Proizvods.Select(x => x.ProizvodId).ToList();
            allProductTypes = naTanjirContext.VrstaProizvoda.Select(x => x.VrstaId).ToList();

            featureVector.AddRange(allProducts.Select(product => proizvod.OcjenaProizvods.Select(x => x.OcjenaProizvodId).Contains(product) ? 1.0 : 0.0));
            featureVector.AddRange(allProductTypes.Select(x => x == proizvod.ProizvodId ? 1.0 : 0.0));

            return featureVector.ToArray();
        }
        public void TrainData()
        {
            if (mlContext == null) mlContext = new MLContext();
            var allProductQuery = naTanjirContext
                        .Proizvods
                        .Include(x => x.VrstaProizvoda);

            var allBooks = allProductQuery.ToList();

            var data = new List<ProizvodEntry>();

            foreach (var item in allBooks)
            {
                foreach (var rb in allBooks)
                {
                    if (rb.ProizvodId == item.ProizvodId)
                        continue;
                    var similarity = ComputeCosineSimilarity(item, rb);
                    data.Add(new ProizvodEntry()
                    {
                        ProizvodId = (uint)item.ProizvodId,
                        CoSimilarProizvodId = (uint)rb.ProizvodId,
                        Label = (float)similarity
                    });

                }
            }

            var traindata = mlContext.Data.LoadFromEnumerable(data);

            MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
            options.MatrixColumnIndexColumnName = nameof(ProizvodEntry.ProizvodId);
            options.MatrixRowIndexColumnName = nameof(ProizvodEntry.CoSimilarProizvodId);
            options.LabelColumnName = "Label";
            options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
            options.Alpha = 0.01;
            options.Lambda = 0.005;
            options.NumberOfIterations = 100;
            options.C = 0.00001;
            var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

            model = est.Fit(traindata);

            using (var fs = new FileStream(ModelPath, FileMode.Create, FileAccess.Write, FileShare.Write))
            {
                mlContext.Model.Save(model, traindata.Schema, fs);
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
        public uint CoSimilarProizvodId { get; set; }

        public float Label { get; set; }
    }
}
