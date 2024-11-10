using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model
{
    public class Lokacija
    {
        public int LokacijaId { get; set; }
        public string? Adresa { get; set; }
        public int? KorisnikId { get; set; }
        public decimal GeografskaDuzina { get; set; }

        public decimal GeografskaSirina { get; set; }

    }
}
