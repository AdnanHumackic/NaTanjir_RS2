using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class OcjenaProizvodUpdateRequest
    {
        public DateTime DatumKreiranja { get; set; }

        public decimal Ocjena { get; set; }

        public bool IsDeleted { get; set; }
        public DateTime? VrijemeBrisanja { get; set; }

    }
}
