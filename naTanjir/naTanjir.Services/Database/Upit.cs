using System;
using System.Collections.Generic;

namespace naTanjir.Services.Database;

public partial class Upit:ISoftDelete
{
    public int UpitId { get; set; }

    public string Naslov { get; set; } = null!;

    public string Sadrzaj { get; set; } = null!;

    public DateTime DatumKreiranja { get; set; }

    public string? Odgovor { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public int KorisnikId { get; set; }

    public int RestoranId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual Restoran Restoran { get; set; } = null!;
}
