using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class RestoranFavoritSearchObject:BaseSearchObject
    {
        public string? RestoranNazivGTE { get; set; }
        //public string? KorisnikImeGTE{ get; set; }
        //public string? KorisnikPrezimeGTE { get; set; }
        //public string? KorisnikImePrezimeGTE { get; set; }

        public int? KorisnikId { get; set; }

        public int? RestoranId { get; set; }

        public bool? IsRestoranIncluded { get; set; }
        public bool? IsDeleted { get; set; }
    }
}
