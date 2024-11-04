using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.Auth;
using naTanjir.Services.BaseServices.Implementation;
using naTanjir.Services.Database;
using naTanjir.Services.NarudzbaStateMachine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StavkeNarudzbe = naTanjir.Services.Database.StavkeNarudzbe;

namespace naTanjir.Services
{
    public class NarudzbaService : BaseCRUDServiceAsync<Model.Narudzba, NarudzbaSearchObject, Database.Narudzba, NarudzbaInsertRequest, NarudzbaUpdateRequest>, INarudzbaService
    {
        public BaseNarudzbaState BaseNarudzbaState { get; set; }
        public NarudzbaService(NaTanjirContext context, IMapper mapper, BaseNarudzbaState baseNarudzbaState) : base(context, mapper)
        {
            BaseNarudzbaState = baseNarudzbaState;
        }

        public override IQueryable<Narudzba> AddFilter(NarudzbaSearchObject searchObject, IQueryable<Narudzba> query)
        {
            query = base.AddFilter(searchObject, query);

            if (searchObject.BrojNarudzbe != null)
            {
                query = query.Where(x => x.BrojNarudzbe.ToString().StartsWith(searchObject.BrojNarudzbe.ToString()));
            }

            if (searchObject.UkupnaCijena != null)
            {
                query = query.Where(x => x.UkupnaCijena == searchObject.UkupnaCijena);
            }

            if (searchObject.DatumKreiranja != null)
            {
                query = query.Where(x => x.DatumKreiranja == searchObject.DatumKreiranja);
            }

            if (searchObject.DatumKreiranjaGTE != null)
            {
                query = query.Where(x => x.DatumKreiranja >= searchObject.DatumKreiranjaGTE);
            }

            if (searchObject.DatumKreiranjaLTE != null)
            {
                query = query.Where(x => x.DatumKreiranja <= searchObject.DatumKreiranjaLTE);
            }

            if (searchObject.StateMachine != null && searchObject.StateMachine.Any())
            {
                query = query.Where(x => searchObject.StateMachine.Contains(x.StateMachine));
            }

            if (searchObject.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (searchObject.RestoranId != null)
            {
                query=query.Where(x=>x.StavkeNarudzbes.Any(e=>e.RestoranId==searchObject.RestoranId));
            }

            if (searchObject.IsKorisnikIncluded == true)
            {
                query = query.Include(x => x.Korisnik);
            }

            if (searchObject.IsStavkeNarudzbeIncluded == true)
            {
                query = query.Include(x => x.StavkeNarudzbes);
            }

            if (searchObject.IsDeleted == true)
            {
                query = query.Where(x => x.IsDeleted == searchObject.IsDeleted);
            }

            return query;
        }

        public override async Task BeforeInsertAsync(NarudzbaInsertRequest request, Narudzba entity, CancellationToken cancellationToken = default)
        {
            if (request?.KorisnikId == null || request.KorisnikId == 0)
            {
                throw new UserException("Molimo unesite korisnik id.");
            }

            if (request?.BrojNarudzbe == null || request.BrojNarudzbe == 0)
            {
                throw new UserException("Molimo unesite broj narudzbe.");
            }

            if (request?.UkupnaCijena == null || request.UkupnaCijena <= 0)
            {
                throw new UserException("Molimo unesite ukupnu cijenu koja mora bit veća od 0.");
            }

            if (request?.DatumKreiranja == null)
            {
                entity.DatumKreiranja = DateTime.Now;
            }

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }
        public override async Task BeforeUpdateAsync(NarudzbaUpdateRequest request, Narudzba entity, CancellationToken cancellationToken = default)
        {
            await base.BeforeUpdateAsync(request, entity, cancellationToken);

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite stauts narudzbe.");
            }
        }

        public override async Task<Model.Narudzba> InsertAsync(NarudzbaInsertRequest request, CancellationToken cancellationToken = default)
        {
            var state = BaseNarudzbaState.CreateState("initial");
            return await state.Insert(request);
        }

        public override async Task<Model.Narudzba> UpdateAsync(int id, NarudzbaUpdateRequest request, CancellationToken cancellationToken = default)
        {
            var entity = await GetByIdAsync(id);
            var state = BaseNarudzbaState.CreateState(entity.StateMachine);
            return await state.Update(id, request);
        }

        public async Task<Model.Narudzba> PreuzmiAsync(int narudzbaId, CancellationToken cancellationToken = default)
        {
            var narudzba = await Context.Narudzbas.FindAsync(narudzbaId, cancellationToken);

            if (narudzba == null)
                throw new UserException("Pogresan id.");

            var state =BaseNarudzbaState.CreateState(narudzba.StateMachine);

            return await state.Preuzeta(narudzbaId);
        }
      
        public async Task<Model.Narudzba> UTokuAsync(int narudzbaId, CancellationToken cancellationToken = default)
        {
            var narudzba = await Context.Narudzbas.FindAsync(narudzbaId, cancellationToken);

            if (narudzba == null)
                throw new UserException("Pogresan id.");

            var state = BaseNarudzbaState.CreateState(narudzba.StateMachine);

            return await state.UToku(narudzbaId);
        }

        public async Task<Model.Narudzba> PonistiAsync(int narudzbaId, CancellationToken cancellationToken = default)
        {
            var narudzba = await Context.Narudzbas.FindAsync(narudzbaId, cancellationToken);

            if (narudzba == null)
                throw new UserException("Pogresan id.");

            var state = BaseNarudzbaState.CreateState(narudzba.StateMachine);

            return await state.Ponistena(narudzbaId);
        }

        public async Task<Model.Narudzba> ZavrsiAsync(int narudzbaId, CancellationToken cancellationToken = default)
        {
            var narudzba = await Context.Narudzbas.FindAsync(narudzbaId, cancellationToken);

            if (narudzba == null)
                throw new UserException("Pogresan id.");

            var state = BaseNarudzbaState.CreateState(narudzba.StateMachine);

            return await state.Zavrsena(narudzbaId);
        }

        public async Task<List<string>> AllowedActions(int narudzbaId, CancellationToken cancellationToken = default)
        {
            var narudzba = await Context.Narudzbas.FindAsync(narudzbaId, cancellationToken);
            if (narudzba == null)
                throw new UserException("Pogresan id.");

            var state = BaseNarudzbaState.CreateState(narudzba.StateMachine);
            return state.AllowedActions(narudzba);
        }
    }
}
