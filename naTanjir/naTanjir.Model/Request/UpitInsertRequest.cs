using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class UpitInsertRequest
    {
        public string Naslov { get; set; } 

        public string Sadržaj { get; set; }
        public int RestoranId { get; set; }
        public int KorisnikId { get; set; }


    }
}
