using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class ProizvodiSearchObject : BaseSearchObject
    {
        public string? NazivGTE { get; set; }
        public string? VrstaProizvodaNazivGTE { get;set; }
        public List<int>? RestoranId { get; set; }
        public List<int>? VrstaProizvodaId { get; set; }
        public int? VlasnikRestoranaId { get; set; }
        public string? NazivRestoranaGTE { get; set; }
        public bool? IsVrstaIncluded { get; set; }
        public bool? IsRestoranIncluded { get; set; }

        public bool? IsDeleted { get; set; }
    }
}
