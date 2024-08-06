using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model
{
    public class OcjenaProizvod
    {
        public int OcjenaProizvodId { get; set; }

        public DateTime DatumKreiranja { get; set; }

        public decimal Ocjena { get; set; }

        public bool IsDeleted { get; set; }

        public int ProizvodId { get; set; }

        public int KorisnikId { get; set; }

        public virtual Korisnici Korisnik { get; set; } 

        public virtual Proizvod Proizvod { get; set; } 
    }
}
