using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Identity.Client;
using naTanjir.Model.Exceptions;
using naTanjir.Model.Request;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.NarudzbaStateMachine
{
    public class BaseNarudzbaState
    {
        public NaTanjirContext Context { get; set; }
        public IMapper Mapper { get; set; }
        public IServiceProvider ServiceProvider { get; set; }
        public BaseNarudzbaState(NaTanjirContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            Context = context;
            Mapper = mapper;
            ServiceProvider = serviceProvider;
        }

        public virtual Model.Narudzba Insert(NarudzbaInsertRequest request)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Model.Narudzba Update(int id, NarudzbaUpdateRequest request)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Model.Narudzba Kreirana(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Model.Narudzba Ponistena(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual Model.Narudzba Preuzeta(int id)
        {
            throw new UserException("Method not allowed");
        }
        public virtual Model.Narudzba UToku(int id)
        {
            throw new UserException("Method not allowed");
        }
        public virtual Model.Narudzba Zavrsena(int id)
        {
            throw new UserException("Method not allowed");
        }

        public BaseNarudzbaState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                    return ServiceProvider.GetService<InitialNarudzbaState>();
                case "kreirana":
                    return ServiceProvider.GetService<KreiranaNarudzbaState>();
                case "preuzeta":
                    return ServiceProvider.GetService<PreuzetaNarudzbaState>();
                case "ponistena":
                    return ServiceProvider.GetService<PreuzetaNarudzbaState>();
                default:throw new UserException("State not recognized");

            }
        }
    }
}
