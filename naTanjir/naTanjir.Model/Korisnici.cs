﻿using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model
{
    public class Korisnici
    {
        public int KorisnikId { get; set; }

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string Telefon { get; set; } = null!;

        public string KorisnickoIme { get; set; } = null!;
        public byte[] Slika { get; set; }


        public bool IsDeleted { get; set; }

        public DateTime DatumRodjenja { get; set; }

        public virtual ICollection<KorisniciUloge> KorisniciUloges { get; set; }
        public int? RestoranId { get; set; }
        public virtual Restoran? Restoran { get; set; }


    }
}
