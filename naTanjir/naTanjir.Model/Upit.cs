using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model
{
    public class Upit
    {
        public int UpitId { get; set; }

        public string Naslov { get; set; } 

        public string Sadržaj { get; set; }

        public string Odgovor { get; set; }

        public int KorisnikId { get; set; }

        public int RestoranId { get; set; }

        public virtual Korisnici Korisnik { get; set; }

        //public virtual Restoran Restoran { get; set; }
    }
}
