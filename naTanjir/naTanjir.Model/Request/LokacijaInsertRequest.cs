using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class LokacijaInsertRequest
    {
        public int? KorisnikId { get; set; }
        public string? Adresa { get; set; }

        public decimal? GeografskaDuzina { get; set; }

        public decimal? GeografskaSirina { get; set; }
    }
}
