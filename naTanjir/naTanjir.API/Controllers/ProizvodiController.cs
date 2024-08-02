﻿using Microsoft.AspNetCore.Mvc;
using naTanjir.Model;
using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using naTanjir.Services;

namespace naTanjir.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProizvodiController : BaseCRUDController<Model.Proizvod, ProizvodiSearchObject, ProizvodiInsertRequest, ProizvodiUpdateRequest>
    {
        protected IProizvodiService _service;

        public ProizvodiController(IProizvodiService service)
            : base(service)
        {
        }

    }
}