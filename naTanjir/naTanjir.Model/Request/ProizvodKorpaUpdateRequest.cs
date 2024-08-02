using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class ProizvodKorpaUpdateRequest
    {
        public int ProizvodId { get; set; }
        public int Kolicina { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? VrijemeBrisanja { get; set; }

    }
}
