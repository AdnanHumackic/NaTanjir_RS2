using MapsterMapper;
using naTanjir.Model;
using naTanjir.Model.Request;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.NarudzbaStateMachine
{
    public class InitialNarudzbaState : BaseNarudzbaState
    {
        public InitialNarudzbaState(Database.NaTanjirContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Narudzba Insert(NarudzbaInsertRequest request)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = Mapper.Map<Database.Narudzba>(request);
            entity.StateMachine = "kreirana";
            set.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<Narudzba>(entity);
        }
    }
}
