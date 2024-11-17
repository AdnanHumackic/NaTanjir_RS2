using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.Messages
{
    public class Email
    {
        public string EmailTo { get; set; }
        public string ReceiverName { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
    }
}
