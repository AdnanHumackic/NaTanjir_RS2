using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class OcjenaRestoranInsertRequest
    {
        public DateTime DatumKreiranja { get; set; }

        public decimal Ocjena { get; set; }

        public int RestoranId { get; set; }

        public int KorisnikId { get; set; }
    }
}
