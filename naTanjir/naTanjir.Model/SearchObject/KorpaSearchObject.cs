using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class KorpaSearchObject:BaseSearchObject
    {
        public int? KorisnikId { get; set; }
        public bool? IsKorisnikIncluded { get; set; }

    }
}
