using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class KorisniciUpdateRequest
    {
        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string? Telefon { get; set; } = null!;

        public string? Lozinka { get; set; }
        public string? LozinkaPotvrda { get; set; }

        public bool IsDeleted { get; set; }
        public DateTime? VrijemeBrisanja { get; set; }


        public DateTime DatumRodjenja { get; set; }
    }
}
