using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class StavkeNarudzbeSearchObject:BaseSearchObject
    {
        public decimal? CijenaLTE { get; set; }
        public decimal? CijenaGTE { get; set; }

        public int? NarudzbaId { get; set; }

        public int? ProizvodId { get; set; }

        public int? RestoranId { get; set; }
        public bool? IsDeleted { get; set; }
        public bool? IsProizvodIncluded { get; set; }
        public bool? IsRestoranIncluded { get; set; }

    }
}
