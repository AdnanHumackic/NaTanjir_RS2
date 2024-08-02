using System;
using System.Collections.Generic;

namespace naTanjir.Services.Database;

public partial class Korpa
{
    public int KorpaId { get; set; }

    public int KorisnikId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual ICollection<ProizvodKorpa> ProizvodKorpas { get; set; } = new List<ProizvodKorpa>();
}
