using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class StavkeNarudzbeInsertRequest
    {
        public int Kolicina { get; set; }

        public decimal Cijena { get; set; }

        public int NarudzbaId { get; set; }

        public int ProizvodId { get; set; }

        public int RestoranId { get; set; }
    }
}
