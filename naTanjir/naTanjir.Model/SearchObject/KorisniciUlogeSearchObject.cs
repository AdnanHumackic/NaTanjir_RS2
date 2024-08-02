using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class KorisniciUlogeSearchObject:BaseSearchObject
    {
        public int? KorisnikId { get; set; }

        public int? UlogaId { get; set; }

        public bool? IsUlogaIncluded { get; set; }
        public bool? IsDeleted { get; set; }
    }
}
