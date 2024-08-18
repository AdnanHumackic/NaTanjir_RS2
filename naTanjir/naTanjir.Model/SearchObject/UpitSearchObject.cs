using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class UpitSearchObject:BaseSearchObject
    {
        public string? ImeGTE { get; set; }
        public string? PrezimeGTE { get; set; }
        public string? ImePrezimeGTE { get; set; }
        public int? KorisnikId { get; set; }
        public int? RestoranId { get; set; }
        public string? RestoranNazivGTE { get; set; }
        public bool? Odgovoreno { get; set; }
    }
}
