using EasyNetQ;
using Mapster;
using MapsterMapper;
using Microsoft.AspNetCore.SignalR;
using naTanjir.Model.Messages;
using naTanjir.Services.Database;
using naTanjir.Services.RabbitMQ;
using naTanjir.Services.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace naTanjir.Services.NarudzbaStateMachine
{
    public class PreuzetaNarudzbaState : BaseNarudzbaState
    {
        private readonly IHubContext<SignalRHubService> _hubContext;
        public PreuzetaNarudzbaState(NaTanjirContext context, IMapper mapper, IServiceProvider serviceProvider,
            IHubContext<SignalRHubService>hubContext) : base(context, mapper, serviceProvider)
        {
            _hubContext = hubContext;
        }

        public override async Task<Model.Narudzba> UToku(int id)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = set.Find(id);
            entity.StateMachine = "uToku";
            await Context.SaveChangesAsync();

            var mappedEntity= Mapper.Map<Model.Narudzba>(entity);

            var kupac=Context.Korisnicis.Where(x=>x.KorisnikId==entity.KorisnikId).FirstOrDefault();
            
            if (kupac != null)
            {
                await _hubContext.Clients.Group(kupac.KorisnickoIme)
                    .SendAsync("ReceiveMessage", $"Poštovani, vaša narudžba #{entity.BrojNarudzbe}" +
                    " je preuzeta od strane dostavljača, te je na putu prema vama.");

                Console.WriteLine("Notifikacija poslana: " + kupac.KorisnickoIme);

            }
            return mappedEntity;
        }
        public override List<string> AllowedActions(Database.Narudzba entity)
        {
            return new List<string>() { nameof(UToku) };
        }
    }
}
