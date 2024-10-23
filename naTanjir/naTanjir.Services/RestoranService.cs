using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.BaseServices.Implementation;
using naTanjir.Services.Database;
using naTanjir.Services.Validator.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public class RestoranService : BaseCRUDServiceAsync<Model.Restoran, RestoranSearchObject, Database.Restoran, RestoranInsertRequest, RestoranUpdateRequest>, IRestoranService
    {
        private readonly IRestoranValidatorService restoranValidator;

        public RestoranService(NaTanjirContext context, IMapper mapper, 
            IRestoranValidatorService restoranValidator) : base(context, mapper)
        {
            this.restoranValidator = restoranValidator;
        }

        public override IQueryable<Restoran> AddFilter(RestoranSearchObject searchObject, IQueryable<Restoran> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.NazivGTE))
            {
                query = query.Where(x => x.Naziv.StartsWith(searchObject.NazivGTE));
            }

            if(searchObject.VrstaRestoranaId!=null)
            {
                query = query.Where(x => searchObject.VrstaRestoranaId.Contains(x.VrstaRestoranaId));
            }

            if (searchObject.IsVrstaRestoranaIncluded == true)
            {
                query = query.Include(x => x.VrstaRestorana);
            }

            if (searchObject.IsDeleted == true)
            {
                query = query.Where(x => x.IsDeleted == searchObject.IsDeleted);
            }

            return query;
        }

        public override async Task BeforeInsertAsync(RestoranInsertRequest request, Restoran entity, CancellationToken cancellationToken = default)
        {
            this.restoranValidator.ValidateRestoranIns(request);

            if (string.IsNullOrWhiteSpace(request.RadnoVrijemeOd))
            {
                throw new UserException("Molimo unesite radno vrijeme od.");
            }

            if (string.IsNullOrWhiteSpace(request.RadnoVrijemeDo))
            {
                throw new UserException("Molimo unesite radno vrijeme do.");
            }

            if (string.IsNullOrWhiteSpace(request.Lokacija))
            {
                throw new UserException("Molimo unesite lokaciju restorana.");
            }

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeUpdateAsync(RestoranUpdateRequest request, Restoran entity, CancellationToken cancellationToken = default)
        {
            await base.BeforeUpdateAsync(request, entity, cancellationToken);

            if (string.IsNullOrWhiteSpace(request.RadnoVrijemeOd))
            {
                throw new UserException("Molimo unesite radno vrijeme od.");
            }

            if (string.IsNullOrWhiteSpace(request.RadnoVrijemeDo))
            {
                throw new UserException("Molimo unesite radno vrijeme do.");
            }

            if (string.IsNullOrWhiteSpace(request.Lokacija))
            {
                throw new UserException("Molimo unesite lokaciju restorana.");
            }

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite status restorana.");
            }
        }

        public override async Task BeforeDeleteAsync(Restoran entity, CancellationToken cancellationToken)
        {
            await base.BeforeDeleteAsync(entity, cancellationToken);

            try
            {
                var stavkeNarudzbe = await Context.StavkeNarudzbes
                .Include(s => s.Narudzba)
                .Where(s => s.RestoranId == entity.RestoranId)
                .ToListAsync();

                if (stavkeNarudzbe != null && stavkeNarudzbe.Any())
                {
                    Context.RemoveRange(stavkeNarudzbe);

                    var narudzbe = stavkeNarudzbe.Select(s => s.Narudzba).Where(n => n != null).Distinct().ToList();
                    if (narudzbe.Any())
                    {
                        Context.RemoveRange(narudzbe);
                    }
                }


                var restFav = await Context.RestoranFavorits
                    .Where(e => e.RestoranId == entity.RestoranId)
                    .ToListAsync();

                if (restFav != null && restFav.Any())
                {
                    Context.RemoveRange(restFav);
                }

                var ocjRestoran = await Context.OcjenaRestorans
                    .Where(e => e.RestoranId == entity.RestoranId)
                    .ToListAsync();

                if (ocjRestoran != null && ocjRestoran.Any())
                {
                    Context.RemoveRange(ocjRestoran);
                }

                var ocjProiz = await Context.OcjenaProizvods
                    .Include(o => o.Proizvod)
                    .Where(o => o.Proizvod.RestoranId == entity.RestoranId)
                    .ToListAsync();

                if (ocjProiz != null && ocjProiz.Any())
                {
                    Context.RemoveRange(ocjProiz);
                }

                var proizvodi = await Context.Proizvods
                    .Where(p => p.RestoranId == entity.RestoranId)
                    .ToListAsync();

                if (proizvodi != null && proizvodi.Any())
                {
                    Context.RemoveRange(proizvodi);
                }
               
                await Context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new UserException("Greska prilikom brisanja.");
            }
        }
        public override async Task AfterDeleteAsync(Restoran entity, CancellationToken cancellationToken)
        {
            var vlasnik = await Context.Korisnicis
                .Where(x => x.KorisnikId == entity.VlasnikId)
                   .FirstOrDefaultAsync();

            if (vlasnik != null)
            {
                Context.Remove(vlasnik);
            }
            var radniciRest = new[] { "RadnikRestorana", "Dostavljac", "Vlasnik" };

            var radniciZaObrisati = await Context.KorisniciUloges
                .Where(x => x.KorisnikId == entity.VlasnikId ||
                            radniciRest.Contains(x.Uloga.Naziv))
                .ToListAsync();

            if (radniciZaObrisati != null && radniciZaObrisati.Count > 0)
            {
                Context.KorisniciUloges.RemoveRange(radniciZaObrisati);
            }
            await Context.SaveChangesAsync();
            await base.AfterDeleteAsync(entity, cancellationToken);
        }
    }
}
