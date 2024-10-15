using MapsterMapper;
using naTanjir.Model;
using naTanjir.Model.Request;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.NarudzbaStateMachine
{
    public class KreiranaNarudzbaState : BaseNarudzbaState
    {
        public KreiranaNarudzbaState(NaTanjirContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<Model.Narudzba> Update(int id, NarudzbaUpdateRequest request)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = set.Find(id);
            Mapper.Map(request, entity);
            await Context.SaveChangesAsync();

            return Mapper.Map<Model.Narudzba>(entity);
        }

        public override async Task<Model.Narudzba> Preuzeta(int id)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = set.Find(id);
            entity.StateMachine = "preuzeta";
            await Context.SaveChangesAsync();

            return Mapper.Map<Model.Narudzba>(entity);
        }
        public override async Task<Model.Narudzba>Ponistena(int id)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = set.Find(id);
            entity.StateMachine = "ponistena";
            Context.SaveChanges();

            return Mapper.Map<Model.Narudzba>(entity);
        }

        public override List<string> AllowedActions(Database.Narudzba entity)
        {
            return new List<string>() { nameof(Update), nameof(Preuzeta), nameof(Ponistena) };
        }
    }
}
