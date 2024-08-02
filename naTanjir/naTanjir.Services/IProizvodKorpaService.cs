﻿using naTanjir.Model.Request;
using naTanjir.Model.SearchObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services
{
    public interface IProizvodKorpaService:ICRUDService<Model.ProizvodKorpa, ProizvodKorpaSearchObject,ProizvodKorpaInsertRequest, ProizvodKorpaUpdateRequest>
    {
    }
}
 