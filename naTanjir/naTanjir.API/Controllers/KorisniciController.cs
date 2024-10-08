﻿using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Storage;
using naTanjir.API.Controllers.BaseControllers;
using naTanjir.Model;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisniciController:BaseCRUDControllerAsync<Model.Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>
    {
        public KorisniciController(IKorisniciService service)
            : base(service)
        {
        }

       [HttpPost("login")]
       [AllowAnonymous]
       public Model.Korisnici Login(string username, string password)
       {
           return (_service as IKorisniciService).Login(username, password);
       }
    }
}
