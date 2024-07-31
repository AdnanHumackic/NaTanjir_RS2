using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class RestoranFavoritSearchObject:BaseSearchObject
    {
        public int? KorisnikId { get; set; }

        public int? RestoranId { get; set; }

        public bool? IsRestoranIncluded { get; set; }
        public bool? IsDeleted { get; set; }
    }
}
