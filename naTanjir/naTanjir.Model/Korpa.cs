using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model
{
    public class Korpa
    {
        public int KorpaId { get; set; }

        public int KorisnikId { get; set; }

        public virtual Korisnici Korisnik { get; set; } 

        public virtual ICollection<ProizvodKorpa> ProizvodKorpas { get; set; } = new List<ProizvodKorpa>();
    }
}
