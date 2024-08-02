using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class ProizvodKorpaInsertRequest
    {
        public int ProizvodId { get; set; }

        public int KorpaId { get; set; }

        public int Kolicina { get; set; }
    }
}
