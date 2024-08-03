﻿using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using naTanjir.Model;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class RestoranController:BaseCRUDController<Model.Restoran, RestoranSearchObject, RestoranInsertRequest, RestoranUpdateRequest>
    {
        public RestoranController(IRestoranService service)
            : base(service)
        {
        }
        
    }
}