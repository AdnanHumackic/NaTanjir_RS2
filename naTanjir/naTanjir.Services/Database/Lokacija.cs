using System;
using System.Collections.Generic;

namespace naTanjir.Services.Database;

public partial class Lokacija:ISoftDelete
{
    public int LokacijaId { get; set; }

    public decimal GeografskaDuzina { get; set; }

    public decimal GeografskaSirina { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual ICollection<Korisnici> Korisnicis { get; set; } = new List<Korisnici>();
}
