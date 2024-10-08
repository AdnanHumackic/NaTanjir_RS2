﻿using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Client.Extensibility;
using naTanjir.Model;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.BaseServices.Implementation;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public class ProizvodiService : BaseCRUDServiceAsync<Model.Proizvod, ProizvodiSearchObject, Database.Proizvod, ProizvodiInsertRequest, ProizvodiUpdateRequest>, IProizvodiService
    {
        public ProizvodiService(NaTanjirContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Proizvod> AddFilter(ProizvodiSearchObject searchObject, IQueryable<Database.Proizvod> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.NazivGTE))
            {
                query = query.Where(x => x.Naziv.StartsWith(searchObject.NazivGTE));
            }
            if (searchObject.RestoranId != null)
            {
                query = query.Where(x => x.RestoranId == searchObject.RestoranId);
            }
            if (searchObject.VrstaProizvodaId != null)
            {
                query = query.Where(x => searchObject.VrstaProizvodaId.Contains(x.VrstaProizvodaId));
            }

            if (searchObject.IsVrstaIncluded == true)
            {
                query = query.Include(x=>x.VrstaProizvoda);
            }

            if (searchObject.IsDeleted == true)
            {
                query = query.Where(x=>x.IsDeleted==searchObject.IsDeleted);
            }
            return query;
        }

        public override async Task BeforeInsertAsync(ProizvodiInsertRequest request, Database.Proizvod entity, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(request.Naziv))
            {
                throw new UserException("Molimo unesite naziv proizvoda.");
            }

            if (string.IsNullOrWhiteSpace(request.Opis))
            {
                throw new UserException("Molimo unesite opis proizvoda.");
            }

            if (request?.Cijena == null || request.Cijena <= 0)
            {
                throw new UserException("Molimo unesite validnu cijenu.");
            }

            if (request.VrstaProizvodaId == 0 || request?.VrstaProizvodaId == null)
            {
                throw new UserException("Molimo unesite tip proizvoda.");
            }

            if (request.RestoranId == 0 || request?.RestoranId == null)
            {
                throw new UserException("Molimo unesite restoran kojem proizvod pripada.");
            }

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeUpdateAsync(ProizvodiUpdateRequest request, Database.Proizvod entity, CancellationToken cancellationToken = default)
        {
            await base.BeforeUpdateAsync(request, entity, cancellationToken);

            if (string.IsNullOrWhiteSpace(request.Naziv))
            {
                throw new UserException("Molimo unesite naziv proizvoda.");
            }

            if (string.IsNullOrWhiteSpace(request.Opis))
            {
                throw new UserException("Molimo unesite opis proizvoda.");
            }

            if (request.Cijena == 0 || request.Cijena < 0)
            {
                throw new UserException("Molimo unesite validnu cijenu.");
            }

            if (request.VrstaProizvodaId == 0 || request?.VrstaProizvodaId == null)
            {
                throw new UserException("Molimo unesite tip proizvoda.");
            }

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite status restorana.");
            }
        }
    }
}
