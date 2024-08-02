using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class UlogeSearchObject:BaseSearchObject
    {
        public string? NazivGTE { get; set; }
        public bool? IsDeleted { get; set; }


    }
}
