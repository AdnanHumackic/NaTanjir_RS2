using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class OcjenaProizvodSearchObject:BaseSearchObject
    {
        public string? ProizvodNazivGTE { get; set; }
        public DateTime? DatumKreiranjaGTE { get; set; }
        public DateTime? DatumKreiranjaLTE { get; set; }

        public decimal? OcjenaGTE { get; set; }
        public decimal? OcjenaLTE { get; set; }

        public bool? IsDeleted { get; set; }

        public int? ProizvodId { get; set; }

        public int? KorisnikId { get; set; }
        public bool? IsProizvodIncluded { get; set; }
        public bool? IsKorisnikIncluded { get; set; }

    }
}
