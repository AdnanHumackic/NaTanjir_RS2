using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class KorisniciSearchObject:BaseSearchObject
    {
        public int? KorisnikId { get; set; }
        public string? ImeGTE { get; set; }
        public string? PrezimeGTE { get; set; }
        public string? ImePrezimeGTE { get; set; }
        public string? EmailGTE { get; set; }
        public string? KorisnickoIme { get; set; }
        public string? Uloga { get; set; }
        public bool? IsKorisniciUlogeIncluded { get; set; }  
        public bool? IsRestoranIncluded { get; set; }
        public int? VlasnikRestoranaId { get; set; }
        public bool? IsDeleted { get; set; }
        public List<int>? RestoranId { get; set; }
    }
}
