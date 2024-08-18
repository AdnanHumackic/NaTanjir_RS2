using Microsoft.AspNetCore.Http;
using naTanjir.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace naTanjir.Services.Auth
{
    public class ActiveUserServiceAsync : IActiveUserServiceAsync
    {

        private readonly IHttpContextAccessor httpContextAccessor;
        private readonly NaTanjirContext Context;
        public ActiveUserServiceAsync(IHttpContextAccessor httpContextAccessor,
            NaTanjirContext context)
        {
            this.httpContextAccessor = httpContextAccessor;
            this.Context = context;
        }

        public async Task<int?> GetActiveUserIdAsync(CancellationToken cancellationToken = default)
        {
            var activeUser = httpContextAccessor.HttpContext.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            var role = httpContextAccessor.HttpContext.User.FindFirst(ClaimTypes.Role)?.Value;
            var roleDb = Context.Uloges.Select(x => x.Naziv).ToList();

            if (roleDb.Contains(role))
            {
                var activeUserDb = Context.Korisnicis.Where(x => x.KorisnickoIme == activeUser).FirstOrDefault();

                return activeUserDb.KorisnikId;
            }

            return null;
        }

        public async Task<string?> GetActiveUsernameAsync(CancellationToken cancellationToken = default)
        {
            var username = httpContextAccessor.HttpContext.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return username;
        }

        public async Task<string?> GetActiveUserRoleAsync(CancellationToken cancellationToken = default)
        {
            var role = httpContextAccessor.HttpContext.User.FindFirst(ClaimTypes.Role)?.Value;

            var roleDb = Context.Uloges.Select(x => x.Naziv).ToList();

            if (roleDb.Contains(role))
            {
                return role;
            }
            return null;
        }
    }
}
