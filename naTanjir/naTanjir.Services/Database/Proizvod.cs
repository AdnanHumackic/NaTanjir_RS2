using System;
using System.Collections.Generic;

namespace naTanjir.Services.Database;

public partial class Proizvod
{
    public int ProizvodId { get; set; }

    public string Naziv { get; set; } = null!;

    public decimal Cijena { get; set; }

    public string Opis { get; set; } = null!;

    public byte[]? Slika { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public string? StateMachine { get; set; }

    public int VrstaProizvodaId { get; set; }

    public int RestoranId { get; set; }

    public virtual ICollection<OcjenaProizvod> OcjenaProizvods { get; set; } = new List<OcjenaProizvod>();

    public virtual Restoran Restoran { get; set; } = null!;

    public virtual ICollection<StavkeNarudzbe> StavkeNarudzbes { get; set; } = new List<StavkeNarudzbe>();

    public virtual VrstaProizvodum VrstaProizvoda { get; set; } = null!;
}
