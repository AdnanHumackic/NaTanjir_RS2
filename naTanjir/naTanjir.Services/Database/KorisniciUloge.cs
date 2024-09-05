using System;
using System.Collections.Generic;

namespace naTanjir.Services.Database;

public partial class KorisniciUloge
{
    public int KorisnikUlogaId { get; set; }

    public int KorisnikId { get; set; }

    public int UlogaId { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual Uloge Uloga { get; set; } = null!;
}
