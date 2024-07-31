using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class RestoranFavoritUpdateRequest
    {
        public bool IsDeleted { get; set; }
        public DateTime? VrijemeBrisanja { get; set; }

    }
}
