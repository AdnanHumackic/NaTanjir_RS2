using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class LokacijaSearchObject:BaseSearchObject
    {
        public int? KorisnikId{ get; set; }
        public bool? IsDeleted { get; set; }

    }
}
