using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class RestoranUpdateRequest
    {
        public string RadnoVrijemeOd { get; set; } 

        public string RadnoVrijemeDo { get; set; } 

        public byte[]? Slika { get; set; }

        public string Lokacija { get; set; } 

        public bool IsDeleted { get; set; }
        public DateTime? VrijemeBrisanja { get; set; }

    }
}
