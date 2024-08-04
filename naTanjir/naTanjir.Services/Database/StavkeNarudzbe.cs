using System;
using System.Collections.Generic;

namespace naTanjir.Services.Database;

public partial class StavkeNarudzbe:ISoftDelete
{
    public int StavkeNarudzbeId { get; set; }

    public int Kolicina { get; set; }

    public decimal Cijena { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public int? NarudzbaId { get; set; }

    public int ProizvodId { get; set; }

    public int RestoranId { get; set; }

    public virtual Narudzba? Narudzba { get; set; }

    public virtual Proizvod Proizvod { get; set; } = null!;

    public virtual Restoran Restoran { get; set; } = null!;
}
