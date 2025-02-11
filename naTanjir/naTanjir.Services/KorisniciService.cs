﻿using MapsterMapper;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using naTanjir.Model;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services.Auth;
using naTanjir.Services.BaseServices.Implementation;
using naTanjir.Services.Database;
using naTanjir.Services.RabbitMQ;
using naTanjir.Services.Recommender.OrderBased;
using naTanjir.Services.Recommender.UserGradeBased;
using naTanjir.Services.SignalR;
using naTanjir.Services.Validator.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public class KorisniciService:BaseCRUDServiceAsync<Model.Korisnici, KorisniciSearchObject, Database.Korisnici, KorisniciInsertRequest, KorisniciUpdateRequest>, IKorisniciService
    {

        ILogger<KorisniciService> _logger;
        private readonly IRabbitMQService _rabbitMQService;
        private readonly IHubContext<SignalRHubService> _hubContext;
        private readonly IUserGradeRecommenderService _userGradeRecommenderService;
        private readonly IPasswordService _passwordService;
        private readonly IKorisniciValidatorService _korisniciValidator;
        public KorisniciService(NaTanjirContext context, IMapper mapper, ILogger<KorisniciService> logger,
            IRabbitMQService rabbitMQService, IHubContext<SignalRHubService> hubContext,
            IUserGradeRecommenderService userGradeRecommenderService, IPasswordService passwordService,
            IKorisniciValidatorService korisniciValidator) : base(context, mapper)
        {
            _logger = logger;
            _rabbitMQService = rabbitMQService;
            _userGradeRecommenderService = userGradeRecommenderService;
            _hubContext = hubContext;
            _passwordService=passwordService;
            _korisniciValidator= korisniciValidator;
        }

        public override IQueryable<Database.Korisnici> AddFilter(KorisniciSearchObject searchObject, IQueryable<Database.Korisnici> query)
        {
            query = base.AddFilter(searchObject, query);
            if (searchObject.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId==searchObject.KorisnikId);
            }


            if (!string.IsNullOrWhiteSpace(searchObject.ImeGTE))
            {
                query = query.Where(x => x.Ime.StartsWith(searchObject.ImeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject.PrezimeGTE))
            {
                query = query.Where(x => x.Prezime.StartsWith(searchObject.PrezimeGTE));
            }

            if(!string.IsNullOrWhiteSpace(searchObject.ImePrezimeGTE)
                && string.IsNullOrWhiteSpace(searchObject.ImeGTE) 
                && string.IsNullOrWhiteSpace(searchObject.PrezimeGTE))
            {
                query = query.Where(x => (x.Ime + " " + x.Prezime).StartsWith(searchObject.ImePrezimeGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject.EmailGTE))
            {
                query = query.Where(x => x.Email.ToLower().StartsWith(searchObject.EmailGTE.ToLower()));
            }

            if (!string.IsNullOrWhiteSpace(searchObject.Uloga))
            {
                query = query.Include(x => x.KorisniciUloges)
                    .Where(x => x.KorisniciUloges.Any(x => x.Uloga.Naziv == searchObject.Uloga));
            }
            if (!string.IsNullOrWhiteSpace(searchObject.KorisnickoIme))
            {
                query = query.Where(x => x.KorisnickoIme.StartsWith(searchObject.KorisnickoIme));
            }

            if (searchObject.IsKorisniciUlogeIncluded == true)
            {
                query = query.Include(x => x.KorisniciUloges).ThenInclude(x => x.Uloga);
            }
            if (searchObject.IsRestoranIncluded == true)
            {
                query = query.Include(x => x.Restoran);
            }
            if (searchObject.RestoranId != null)
            {
                query = query.Where(x => x.RestoranId.HasValue && searchObject.RestoranId.Contains(x.RestoranId.Value));
            }
            if (searchObject.VlasnikRestoranaId != null) 
            {
                query = query.Where(x => x.Restoran.VlasnikId == searchObject.VlasnikRestoranaId);
            }

            if (searchObject?.IsDeleted != null)
            {
                if (searchObject.IsDeleted == false)
                {
                    query = query.Where(x => x.IsDeleted == false || x.IsDeleted == null);
                }
                else
                {
                    query = query.Where(x => x.IsDeleted == true);
                }
            }

            return query;
        }

        public override async Task BeforeInsertAsync(KorisniciInsertRequest request, Database.Korisnici entity, CancellationToken cancellationToken = default)
        {
            if (request.Lozinka != request.LozinkaPotvrda)
            {
                throw new UserException("Lozinka i LozinkaPotvrda moraju biti iste.");
            }
            _korisniciValidator.ValidateKorisniciIns(request);
            entity.LozinkaSalt = _passwordService.GenerateSalt();
            entity.LozinkaHash = _passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }
       
        public override async Task AfterInsertAsync(KorisniciInsertRequest request, Database.Korisnici entity, CancellationToken cancellationToken = default)
        {
            if (request.Uloge != null)
            {
                foreach(var uloge in request.Uloge)
                {
                    Context.KorisniciUloges.Add(new Database.KorisniciUloge
                    {
                        KorisnikId=entity.KorisnikId,
                        UlogaId=uloge
                    });

                    await Context.SaveChangesAsync(cancellationToken);
                }
            }
            await base.AfterInsertAsync(request, entity, cancellationToken);
        }


        public override async Task BeforeUpdateAsync(KorisniciUpdateRequest request, Database.Korisnici entity, CancellationToken cancellationToken = default)
        {
            await base.BeforeUpdateAsync(request, entity, cancellationToken);
            var currentUsername = Context.Korisnicis.Where(x => x.KorisnikId == entity.KorisnikId).Select(x => x.KorisnickoIme).FirstOrDefault();
            if(request.KorisnickoIme!=currentUsername)
                await _rabbitMQService.SendEmail(new Model.Messages.Email
                {
                    EmailTo = entity.Email,
                    Message = $"Poštovani, vaše korisničko ime je promijenjeno na <b>'{entity.KorisnickoIme}'</b> " +
                                            "jer je prethodno korisničko ime ocijenjeno kao neprimjereno.<br>"+
                                            "Molimo Vas da ubuduće, prilikom prijave, koristite novo korisničko ime.<br>" +
                                            "Srdačan pozdrav, <br>"+
                                            "naTanjir Team",
                    ReceiverName = entity.Ime + " " + entity.Prezime,
                    Subject = "Promjena korisničkog imena"
                });
            _korisniciValidator.ValidateKorisniciUpd(request);
            if (request.NovaLozinka != null)
            {
                if (request.NovaLozinka != request.LozinkaPotvrda)
                {
                    throw new UserException("Lozinka i LozinkaPotvrda moraju biti iste.");
                }
                entity.LozinkaSalt = _passwordService.GenerateSalt();
                entity.LozinkaHash = _passwordService.GenerateHash(entity.LozinkaSalt, request.NovaLozinka);
            }
            entity.IsDeleted = false;
        }

        public Model.Korisnici Login(string username, string password, string connectionId)
        {
            var entity = Context.Korisnicis.Include(x=>x.KorisniciUloges).ThenInclude(y=>y.Uloga).FirstOrDefault(x => x.KorisnickoIme == username);

            if (entity == null)
            {
                return null;
            }

            var hash = _passwordService.GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }
            if (connectionId != "")
            {
                _hubContext.Groups.AddToGroupAsync(connectionId, username);
            }
            return Mapper.Map<Model.Korisnici>(entity);
        }

        public async Task<List<Model.Proizvod>> GetRecommendedGradedProducts(int korisnikId, int restoranId)
        {
            var korisniciOcj = await _userGradeRecommenderService.GetRecommendedGradedProducts(korisnikId, restoranId);

            return korisniciOcj;
        }

        public void TrainData()
        {
           _userGradeRecommenderService.TrainData();
        }
    }
}
