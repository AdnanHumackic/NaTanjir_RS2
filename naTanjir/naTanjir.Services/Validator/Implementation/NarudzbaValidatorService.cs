using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Services.Auth;
using naTanjir.Services.Database;
using naTanjir.Services.Validator.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Validator.Implementation
{
    public class NarudzbaValidatorService : BaseValidatorService<Database.Narudzba>, INarudzbaValidatorService
    {
        private readonly NaTanjirContext Context;
        private readonly IActiveUserService activeUserService;
        public NarudzbaValidatorService(NaTanjirContext context,
            IActiveUserService activeUserService) : base(context)
        {
            this.Context = context;
            this.activeUserService = activeUserService;
        }

        public void ValidateNarudzbaIns(NarudzbaInsertRequest request, Database.Narudzba entity)
        {
            Random random = new Random();
            var rand=random.Next(1000, 10000);
            if (request.BrojNarudzbe <= 0)
            {
                entity.BrojNarudzbe = rand;
            }

            if (request.KorisnikId == 0)
            {
                entity.KorisnikId = activeUserService.GetActiveUserId() ?? throw new UserException("Prijavite se prije kreiranja narudžbe.");
            }

            if (request.DatumKreiranja == null)
            {
                request.DatumKreiranja = DateTime.Now;
            }

            if (request.StavkeNarudzbe == null || request.StavkeNarudzbe.Count == 0)
            {
                throw new UserException("Narudžba mora sadržavati barem jedan proizvod.");
            }

            var firstRestId = request.StavkeNarudzbe.First().RestoranId;

            var validProizvodiIds = Context.Proizvods.Select(p => p.ProizvodId).ToHashSet();

            foreach (var stavka in request.StavkeNarudzbe)
            {
                if (stavka.RestoranId != firstRestId)
                {
                    throw new UserException("Svi proizvodi u narudžbi moraju pripadati istom restoranu.");
                }

                if (!validProizvodiIds.Contains(stavka.ProizvodId))
                {
                    throw new UserException($"Proizvod sa id: {stavka.ProizvodId} ne postoji.");
                }

                if (stavka.Cijena <= 0)
                {
                    var proizvod = Context.Proizvods.FirstOrDefault(p => p.ProizvodId == stavka.ProizvodId);
                    if (proizvod != null)
                    {
                        stavka.Cijena = proizvod.Cijena;
                    }
                    else
                    {
                        throw new UserException($"Cijena proizvoda sa ID {stavka.ProizvodId} nije dostupna.");
                    }
                }
                if (request.UkupnaCijena == 0)
                {
                    entity.UkupnaCijena += stavka.Kolicina * stavka.Cijena;
                }

                if (stavka.Kolicina <= 0)
                {
                    throw new UserException("Količina proizvoda mora biti veća od 0.");
                }
            }
        }

    }
}
