using MapsterMapper;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.NarudzbaStateMachine
{
    public class ZavrsenaNarudzbaState : BaseNarudzbaState
    {
        public ZavrsenaNarudzbaState(NaTanjirContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }
        public override List<string> AllowedActions(Database.Narudzba entity)
        {
            return new List<string>() { };
        }
    }
}
