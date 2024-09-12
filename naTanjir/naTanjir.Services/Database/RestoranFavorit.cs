using System;
using System.Collections.Generic;

namespace naTanjir.Services.Database;

public partial class RestoranFavorit:ISoftDelete
{
    public int RestoranFavoritId { get; set; }

    public DateTime DatumDodavanja { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public int KorisnikId { get; set; }

    public int RestoranId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual Restoran Restoran { get; set; } = null!;
}
