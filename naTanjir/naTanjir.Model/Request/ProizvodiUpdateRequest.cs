using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class ProizvodiUpdateRequest
    {
        public string Naziv { get; set; } = null!;

        public decimal Cijena { get; set; }

        public string Opis { get; set; } = null!;

        public byte[]? Slika { get; set; }

        public bool IsDeleted { get; set; }
        public DateTime? VrijemeBrisanja { get; set; }

        public int VrstaProizvodaId { get; set; }

    }
}
