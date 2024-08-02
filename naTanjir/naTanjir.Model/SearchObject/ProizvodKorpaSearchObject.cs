using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class ProizvodKorpaSearchObject:BaseSearchObject
    {
        public int? ProizvodId { get; set; }

        public int? KorpaId { get; set; }

        public bool? IsDeleted { get; set; }

    }
}
