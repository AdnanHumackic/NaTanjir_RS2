using System;
using System.Collections.Generic;

namespace naTanjir.Services.Database;

public partial class ProizvodKorpa:ISoftDelete
{
    public int ProizvodKorpaId { get; set; }

    public int ProizvodId { get; set; }

    public int KorpaId { get; set; }

    public int Kolicina { get; set; }

    public DateTime DatumDodavanja { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual Korpa Korpa { get; set; } = null!;

    public virtual Proizvod Proizvod { get; set; } = null!;
}
