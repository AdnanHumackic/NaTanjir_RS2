using MapsterMapper;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using naTanjir.Model;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Services.Database;
using naTanjir.Services.SignalR;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.NarudzbaStateMachine
{
    public class KreiranaNarudzbaState : BaseNarudzbaState
    {
        private readonly IHubContext<SignalRHubService> _hubContext;

        public KreiranaNarudzbaState(NaTanjirContext context, IMapper mapper, IServiceProvider serviceProvider,
            IHubContext<SignalRHubService>hubContext) : base(context, mapper, serviceProvider)
        {
            _hubContext = hubContext;
        }

        public override async Task<Model.Narudzba> Update(int id, NarudzbaUpdateRequest request)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = set.Find(id);
            Mapper.Map(request, entity);
            await Context.SaveChangesAsync();

            return Mapper.Map<Model.Narudzba>(entity);
        }

        public override async Task<Model.Narudzba> Preuzeta(int id, int dostavljacId)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = set.Find(id);
            entity.DostavljacId = dostavljacId;
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
            var narudzbaRest = await Context.StavkeNarudzbes.Where(x => x.NarudzbaId == id).Select(x => x.RestoranId).FirstOrDefaultAsync();

            List<string> radniciRestorana = new List<string>();

            var radnici = await Context.Korisnicis
                   .Where(k => k.RestoranId == narudzbaRest &&
                   k.KorisniciUloges.Any(ku => ku.UlogaId == 5))
                   .Select(k => k.KorisnickoIme)
                   .ToListAsync();
            radniciRestorana.AddRange(radnici);

            foreach (var r in radniciRestorana)
            {
                await _hubContext.Clients.Group(r)
                     .SendAsync("ReceiveMessage", $"Poštovani, otkazana je narudžba " +
                    $"#{entity.BrojNarudzbe}.");

            }
            return Mapper.Map<Model.Narudzba>(entity);
        }

        public override List<string> AllowedActions(Database.Narudzba entity)
        {
            return new List<string>() { nameof(Update), nameof(Preuzeta), nameof(Ponistena) };
        }
    }
}
