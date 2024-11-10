using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class LokacijaUpdateRequest
    {
        public decimal? GeografskaDuzina { get; set; }

        public decimal? GeografskaSirina { get; set; }

        public string? Adresa { get; set; }

    }
}
