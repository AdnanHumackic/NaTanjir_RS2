using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class KorisniciUpdateRequest
    {
        public string Ime { get; set; }

        public string Prezime { get; set; }

        public string? Telefon { get; set; }
        public string? KorisnickoIme { get; set; }
        public string? Email { get; set; }
        public byte[]? Slika { get; set; }
        public bool? isDeleted { get; set; }
        public DateTime? VrijemeBrisanja { get; set; }

        public string? NovaLozinka { get; set; }
        public string? LozinkaPotvrda { get; set; }

    }
}
