using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class ProizvodiSearchObject : BaseSearchObject
    {
        public string? NazivGTE { get; set; } 

        public int? VrstaProizvodaId { get; set; }
        public bool? IsVrstaIncluded { get; set; }

        public bool? IsDeleted { get; set; }
    }
}
