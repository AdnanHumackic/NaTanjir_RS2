using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model
{
    public class OcjenaRestoran
    {
        public int OcjenaRestoranId { get; set; }

        public DateTime Datum { get; set; }

        public decimal Ocjena { get; set; }

        public bool IsDeleted { get; set; }

        public int RestoranId { get; set; }

        public int KorisnikId { get; set; }
        public virtual Korisnici Korisnik { get; set; } = null!;

        public virtual Restoran Restoran { get; set; } = null!;
    }
}
