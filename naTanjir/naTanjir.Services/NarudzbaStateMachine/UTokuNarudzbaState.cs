using MapsterMapper;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.NarudzbaStateMachine
{
    public class UTokuNarudzbaState : BaseNarudzbaState
    {
        public UTokuNarudzbaState(NaTanjirContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<Model.Narudzba> Zavrsena(int id)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = set.Find(id);
            entity.StateMachine = "zavrsena";
            await Context.SaveChangesAsync();

            return Mapper.Map<Model.Narudzba>(entity);
        }
        public override List<string> AllowedActions(Database.Narudzba entity)
        {
            return new List<string>() { nameof(Zavrsena) };
        }
    }
}
