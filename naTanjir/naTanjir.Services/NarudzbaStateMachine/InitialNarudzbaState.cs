using MapsterMapper;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using naTanjir.Model;
using naTanjir.Model.Request;
using naTanjir.Services.SignalR;
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
        private readonly IHubContext<SignalRHubService> _hubContext;

        public InitialNarudzbaState(Database.NaTanjirContext context, IMapper mapper, IServiceProvider serviceProvider,
            IHubContext<SignalRHubService> hubContext
            ) : base(context, mapper, serviceProvider)
        {
            _hubContext = hubContext;
        }   

        public override async Task<Narudzba> Insert(NarudzbaInsertRequest request)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = Mapper.Map<Database.Narudzba>(request);
            entity.StateMachine = "kreirana";
            set.Add(entity);
            await Context.SaveChangesAsync();

            var narudzbaId = await Context.Narudzbas.Select(x => x.NarudzbaId).OrderBy(x => x).LastOrDefaultAsync();

            List<string> radniciRestorana = new List<string>(); 

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
                var radnici = await Context.Korisnicis
                    .Where(k => k.RestoranId == stavka.RestoranId && 
                    k.KorisniciUloges.Any(ku=>ku.UlogaId==5))
                    .Select(k => k.KorisnickoIme)
                    .ToListAsync();

                radniciRestorana.AddRange(radnici);
            }
            foreach(var radnici in radniciRestorana)
            {
                await _hubContext.Clients.Group(radnici)
                     .SendAsync("ReceiveMessage", $"Poštovani, kreirana je nova narudžba " +
                    $"#{entity.BrojNarudzbe}. Molimo vas da što prije započnete s njenom pripremom.");

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
