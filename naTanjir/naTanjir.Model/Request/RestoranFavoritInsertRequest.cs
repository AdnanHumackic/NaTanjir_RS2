using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class RestoranFavoritInsertRequest
    {
        public DateTime DatumDodavanja { get; set; }

        public int KorisnikId { get; set; }

        public int RestoranId { get; set; }

    }
}
