using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class UlogeUpdateRequest
    {
        public string Naziv { get; set; } 

        public string? Opis { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? VrijemeBrisanja { get; set; }

    }
}
