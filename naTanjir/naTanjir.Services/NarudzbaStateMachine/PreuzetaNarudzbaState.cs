using MapsterMapper;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.NarudzbaStateMachine
{
    public class PreuzetaNarudzbaState : BaseNarudzbaState
    {
        public PreuzetaNarudzbaState(NaTanjirContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override Model.Narudzba UToku(int id)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = set.Find(id);
            entity.StateMachine = "uToku";
            Context.SaveChanges();

            return Mapper.Map<Model.Narudzba>(entity);
        }

        public override Model.Narudzba Zavrsena(int id)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = set.Find(id);
            entity.StateMachine = "zavrsena";
            Context.SaveChanges();

            return Mapper.Map<Model.Narudzba>(entity);
        }


    }
}
