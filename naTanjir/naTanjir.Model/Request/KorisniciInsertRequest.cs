using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class KorisniciInsertRequest
    {

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string Telefon { get; set; } = null!;

        public string KorisnickoIme { get; set; } = null!;
        public string Lozinka { get; set; }
        public string LozinkaPotvrda { get; set; }

        public DateTime DatumRodjenja { get; set; }
        
        public List<int> Uloge { get; set; }
    }
}
