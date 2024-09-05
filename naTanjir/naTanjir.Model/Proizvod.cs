using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model
{
    public class Proizvod
    {
        public int ProizvodId { get; set; }

        public string Naziv { get; set; } = null!;

        public decimal Cijena { get; set; }

        public string Opis { get; set; } = null!;

        public byte[]? Slika { get; set; }

        public int VrstaProizvodaId { get; set; }

        public int RestoranId { get; set; }
        public virtual VrstaProizvodum VrstaProizvoda { get; set; } = null!;


    }
}
