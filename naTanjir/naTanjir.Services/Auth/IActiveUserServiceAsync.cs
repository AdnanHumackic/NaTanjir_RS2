using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Auth
{
    public interface IActiveUserServiceAsync
    {
        Task<int?> GetActiveUserIdAsync(CancellationToken cancellationToken=default);
        Task<string?> GetActiveUsernameAsync(CancellationToken cancellationToken=default);
        Task<string?> GetActiveUserRoleAsync(CancellationToken cancellationToken=default);
    }
}
