using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model
{
    public class ProizvodKorpa
    {
        //ne radi kao autoinkrement
        public int ProizvodKorpaId { get; set; }

        public int ProizvodId { get; set; }

        public int KorpaId { get; set; }

        public int Kolicina { get; set; }

        public bool IsDeleted { get; set; }
    }
}
