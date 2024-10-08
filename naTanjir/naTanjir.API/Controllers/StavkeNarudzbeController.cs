﻿using Microsoft.AspNetCore.Mvc;
using naTanjir.API.Controllers.BaseControllers;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class StavkeNarudzbeController:BaseCRUDControllerAsync<Model.StavkeNarudzbe, StavkeNarudzbeSearchObject, StavkeNarudzbeInsertRequest, StavkeNarudzbeUpdateRequest>
    {
        public StavkeNarudzbeController(IStavkeNarudzbe service)
            : base(service)
        {
        }
    }
}
