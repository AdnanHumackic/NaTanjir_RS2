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

        public bool IsDeleted { get; set; }

        public int NarudzbaId { get; set; }

        public int ProizvodId { get; set; }

        public int RestoranId { get; set; }

        //public virtual Narudzba Narudzba { get; set; } 

        //public virtual Proizvod Proizvod { get; set; } 

        //public virtual Restoran Restoran { get; set; } 
    }
}
