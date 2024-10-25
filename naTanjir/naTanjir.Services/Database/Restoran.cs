using System;
using System.Collections.Generic;

namespace naTanjir.Services.Database;

public partial class Restoran:ISoftDelete
{
    public int RestoranId { get; set; }

    public string Naziv { get; set; } = null!;

    public string RadnoVrijemeOd { get; set; } = null!;

    public string RadnoVrijemeDo { get; set; } = null!;

    public byte[]? Slika { get; set; }

    public string Lokacija { get; set; } = null!;

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public string? StateMachine { get; set; }

    public int VrstaRestoranaId { get; set; }

    public int VlasnikId { get; set; }

    public virtual ICollection<OcjenaRestoran> OcjenaRestorans { get; set; } = new List<OcjenaRestoran>();

    public virtual ICollection<Proizvod> Proizvods { get; set; } = new List<Proizvod>();

    public virtual ICollection<RestoranFavorit> RestoranFavorits { get; set; } = new List<RestoranFavorit>();

    public virtual ICollection<StavkeNarudzbe> StavkeNarudzbes { get; set; } = new List<StavkeNarudzbe>();

    public virtual ICollection<Upit> Upits { get; set; } = new List<Upit>();

    public virtual Korisnici Vlasnik { get; set; } = null!;

    public virtual VrstaRestorana VrstaRestorana { get; set; } = null!;
}
