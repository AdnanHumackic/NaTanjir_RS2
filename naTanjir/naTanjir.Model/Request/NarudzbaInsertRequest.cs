using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class NarudzbaInsertRequest
    {
        public int BrojNarudzbe { get; set; }

        public decimal UkupnaCijena { get; set; }

        public DateTime DatumKreiranja { get; set; }

        public int KorisnikId { get; set; }
    }
}
