using System;
using System.Collections.Generic;

namespace naTanjir.Services.Database;

public partial class VrstaProizvodum
{
    public int VrstaId { get; set; }

    public string Naziv { get; set; } = null!;

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual ICollection<Proizvod> Proizvods { get; set; } = new List<Proizvod>();
}
