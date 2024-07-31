using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class ProizvodiInsertRequest
    {
        public string Naziv { get; set; }

        public decimal Cijena { get; set; }

        public string Opis { get; set; }

        public byte[]? Slika { get; set; }

        public int VrstaProizvodaId { get; set; }

        public int RestoranId { get; set; }
    }
}
