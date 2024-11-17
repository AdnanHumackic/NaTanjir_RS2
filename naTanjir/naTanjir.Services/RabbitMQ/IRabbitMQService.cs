using naTanjir.Model.Messages;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.RabbitMQ
{
    public interface IRabbitMQService
    {
        Task SendEmail(Email email);
    }
}
