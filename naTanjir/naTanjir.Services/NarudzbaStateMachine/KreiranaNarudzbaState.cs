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

        public override Model.Narudzba Update(int id, NarudzbaUpdateRequest request)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = set.Find(id);
            Mapper.Map(request, entity);
            Context.SaveChanges();

            return Mapper.Map<Model.Narudzba>(entity);
        }

        public override Model.Narudzba Preuzeta(int id)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = set.Find(id);
            entity.StateMachine = "preuzeta";
            Context.SaveChanges();

            return Mapper.Map<Model.Narudzba>(entity);
        }
        public override Model.Narudzba Ponistena(int id)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = set.Find(id);
            entity.StateMachine = "ponistena";
            Context.SaveChanges();

            return Mapper.Map<Model.Narudzba>(entity);
        }

    }
}
