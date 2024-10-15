using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using naTanjir.Model;
using naTanjir.Model.Request;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace naTanjir.Services.NarudzbaStateMachine
{
    public class InitialNarudzbaState : BaseNarudzbaState
    {
        public InitialNarudzbaState(Database.NaTanjirContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<Narudzba> Insert(NarudzbaInsertRequest request)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = Mapper.Map<Database.Narudzba>(request);
            entity.StateMachine = "kreirana";
            set.Add(entity);
            await Context.SaveChangesAsync();

            var narudzbaId = await Context.Narudzbas.Select(x => x.NarudzbaId).OrderBy(x => x).LastOrDefaultAsync();

            foreach (var stavka in request.StavkeNarudzbe)
            {
                var stavkeNarudzbe = new Database.StavkeNarudzbe
                {
                    NarudzbaId = narudzbaId,
                    ProizvodId = stavka.ProizvodId,
                    Kolicina = stavka.Kolicina,
                    Cijena = stavka.Cijena,
                    RestoranId = stavka.RestoranId
                };

                await Context.StavkeNarudzbes.AddAsync(stavkeNarudzbe);
            }
            await Context.SaveChangesAsync();

            return Mapper.Map<Narudzba>(entity);
        }

        public override List<string> AllowedActions(Database.Narudzba entity)
        {
            return new List<string>() { nameof(Insert) };
        }
    }
}
