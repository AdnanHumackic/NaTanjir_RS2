using System;
using System.Collections.Generic;

namespace naTanjir.Services.Database;

public partial class OcjenaProizvod:ISoftDelete
{
    public int OcjenaProizvodId { get; set; }

    public DateTime DatumKreiranja { get; set; }

    public decimal Ocjena { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public int ProizvodId { get; set; }

    public int KorisnikId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual Proizvod Proizvod { get; set; } = null!;
}
