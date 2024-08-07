﻿using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using naTanjir.Model;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.BaseServices.Implementation;
using naTanjir.Services.Database;
using naTanjir.Services.Validator.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public class OcjenaProizvodService : BaseCRUDService<Model.OcjenaProizvod, OcjenaProizvodSearchObject, Database.OcjenaProizvod, OcjenaProizvodInsertRequest, OcjenaProizvodUpdateRequest>, IOcjenaProizvodService
    {
        private readonly IOcjenaProizvodValidatorService ocjenaProizvodValidator;

        public OcjenaProizvodService(NaTanjirContext context, IMapper mapper, 
            IOcjenaProizvodValidatorService ocjenaProizvodValidator) : base(context, mapper)
        {
            this.ocjenaProizvodValidator = ocjenaProizvodValidator;
        }

        public override IQueryable<Database.OcjenaProizvod> AddFilter(OcjenaProizvodSearchObject searchObject, IQueryable<Database.OcjenaProizvod> query)
        {
            query = base.AddFilter(searchObject, query);

            if (searchObject.DatumKreiranjaGTE != null)
            {
                query = query.Where(x => x.DatumKreiranja > searchObject.DatumKreiranjaGTE);
            }

            if (searchObject.DatumKreiranjaLTE != null)
            {
                query = query.Where(x => x.DatumKreiranja < searchObject.DatumKreiranjaLTE);
            }

            if (searchObject.OcjenaGTE != null)
            {
                query = query.Where(x => x.Ocjena > searchObject.OcjenaGTE);
            }

            if (searchObject.OcjenaLTE != null)
            {
                query = query.Where(x => x.Ocjena < searchObject.OcjenaLTE);
            }

            if (searchObject.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (searchObject.ProizvodId != null)
            {
                query = query.Where(x => x.ProizvodId == searchObject.ProizvodId);
            }

            if (searchObject.IsKorisnikIncluded == true)
            {
                query = query.Include(x => x.Korisnik);
            }

            if (searchObject.IsProizvodIncluded == true)
            {
                query = query.Include(x => x.Proizvod);
            }

            if (searchObject.IsDeleted == true)
            {
                query = query.Where(x => x.IsDeleted == searchObject.IsDeleted);
            }

            return query;
        }

        public override void BeforeInsert(OcjenaProizvodInsertRequest request, Database.OcjenaProizvod entity)
        {
            ocjenaProizvodValidator.ValidateOcjenaProizvodtIns(request);

            if (request?.DatumKreiranja == null)
            {
                entity.DatumKreiranja = DateTime.Now;
            }

            if (request?.Ocjena == null || request.Ocjena <= 0 || request.Ocjena > 5)
            {
                throw new UserException("Molimo unesite validnu ocjenu između 1 i 5.");
            }

            base.BeforeInsert(request, entity);
        }

        public override void BeforeUpdate(OcjenaProizvodUpdateRequest request, Database.OcjenaProizvod entity)
        {
            base.BeforeUpdate(request, entity);

            if (request?.DatumKreiranja == null)
            {
                entity.DatumKreiranja = DateTime.Now;
            }

            if (request?.Ocjena == null || request.Ocjena <= 0 || request.Ocjena > 5)
            {
                throw new UserException("Molimo unesite validnu ocjenu između 1 i 5.");
            }

            if (request?.IsDeleted == null)
            {
                throw new UserException("Molimo unesite stauts ocjene.");
            }
        }
    }
}
