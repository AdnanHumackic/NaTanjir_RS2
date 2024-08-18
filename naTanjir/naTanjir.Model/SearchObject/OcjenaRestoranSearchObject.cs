using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class OcjenaRestoranSearchObject:BaseSearchObject
    {
        public string? RestoranNazivGTE { get; set; }
        public DateTime? DatumKreiranjaGTE { get; set; }
        public DateTime? DatumKreiranjaLTE { get; set; }

        public decimal? OcjenaGTE { get; set; }
        public decimal? OcjenaLTE { get; set; }


        public int? RestoranId { get; set; }

        public int? KorisnikId { get; set; }

        public bool? IsKorisnikIncluded { get; set; }

        public bool? IsRestoranIncluded { get; set; }

        public bool? IsDeleted { get; set; }
    }
}
