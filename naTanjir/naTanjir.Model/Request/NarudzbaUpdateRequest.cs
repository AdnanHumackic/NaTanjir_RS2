using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Request
{
    public class NarudzbaUpdateRequest
    {
        public bool IsDeleted { get; set; }

        public bool IsDostavljena { get; set; }
        public bool IsNaPutu { get; set; }

    }
}
