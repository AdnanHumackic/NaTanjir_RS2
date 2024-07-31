using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class RestoranSearchObject:BaseSearchObject
    {
        public string? NazivGTE { get; set; } 
        public int? VrstaRestoranaId { get; set; }
        public bool? IsVrstaRestoranaIncluded { get; set; }
        public bool? IsDeleted { get; set; }
    }
}
