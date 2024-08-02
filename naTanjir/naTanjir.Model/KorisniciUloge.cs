using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model
{
    public class KorisniciUloge
    {
        public int KorisnikUlogaId { get; set; }

        public int KorisnikId { get; set; }

        public int UlogaId { get; set; }

        public bool IsDeleted { get; set; }

        public virtual Uloge Uloga { get; set; } = null!;

    }
}
