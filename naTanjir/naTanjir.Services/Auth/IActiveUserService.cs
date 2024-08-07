using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Auth
{
    public interface IActiveUserService
    {
        int? GetActiveUserId();
        string? GetActiveUsername();
        string? GetActiveUserRole();
    }
}
