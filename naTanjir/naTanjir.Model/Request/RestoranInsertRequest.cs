using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class RestoranInsertRequest
    {
        public string Naziv { get; set; } 

        public string RadnoVrijemeOd { get; set; }

        public string RadnoVrijemeDo { get; set; }

        public byte[]? Slika { get; set; }

        public string Lokacija { get; set; }

        public int VrstaRestoranaId { get; set; }

        public int VlasnikId { get; set; }
    }
}
