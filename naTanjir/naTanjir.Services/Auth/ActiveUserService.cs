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
    public class ActiveUserService : IActiveUserService
    {
        private readonly IHttpContextAccessor httpContextAccessor;
        private readonly NaTanjirContext Context;
        public ActiveUserService(IHttpContextAccessor httpContextAccessor,
            NaTanjirContext context)
        {
            this.httpContextAccessor = httpContextAccessor;
            this.Context = context;
        }
        public int? GetActiveUserId()
        {
            var activeUser= httpContextAccessor.HttpContext.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            var role = httpContextAccessor.HttpContext.User.FindFirst(ClaimTypes.Role)?.Value;
            var roleDb = Context.Uloges.Select(x => x.Naziv).ToList();

            if (roleDb.Contains(role))
            {
                var activeUserDb = Context.Korisnicis.Where(x => x.KorisnickoIme == activeUser).FirstOrDefault();

                return activeUserDb.KorisnikId;
            }

            return null;
        }

        public string? GetActiveUsername()
        {
            var username = httpContextAccessor.HttpContext.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return username;

        }

        public string? GetActiveUserRole()
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
