using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model
{
    public class Restoran
    {
        public int RestoranId { get; set; }

        public string Naziv { get; set; } = null!;

        public string RadnoVrijemeOd { get; set; } = null!;

        public string RadnoVrijemeDo { get; set; } = null!;

        public byte[]? Slika { get; set; }

        public string Lokacija { get; set; } = null!;

        public int VrstaRestoranaId { get; set; }
        public bool? IsDeleted { get; set; }

        public int VlasnikId { get; set; }

        public virtual VrstaRestorana VrstaRestorana { get; set; } 
    }
}
