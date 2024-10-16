using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model
{
    public class StavkeNarudzbe
    {
        public int StavkeNarudzbeId { get; set; }

        public int Kolicina { get; set; }

        public decimal Cijena { get; set; }

        public int NarudzbaId { get; set; }

        public int ProizvodId { get; set; }

        public int RestoranId { get; set; }
        public Proizvod Proizvod { get; set; }
        public Restoran Restoran { get; set; }

    }
}
