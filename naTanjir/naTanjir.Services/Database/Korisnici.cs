using System;
using System.Collections.Generic;

namespace naTanjir.Services.Database;

public partial class Korisnici:ISoftDelete
{
    public int KorisnikId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Telefon { get; set; } = null!;

    public string KorisnickoIme { get; set; } = null!;

    public string LozinkaHash { get; set; } = null!;

    public string LozinkaSalt { get; set; } = null!;

    public byte[]? Slika { get; set; }

    public DateTime DatumRodjenja { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public int? LokacijaId { get; set; }

    public virtual ICollection<KorisniciUloge> KorisniciUloges { get; set; } = new List<KorisniciUloge>();

    public virtual Lokacija? Lokacija { get; set; }

    public virtual ICollection<Narudzba> Narudzbas { get; set; } = new List<Narudzba>();

    public virtual ICollection<OcjenaProizvod> OcjenaProizvods { get; set; } = new List<OcjenaProizvod>();

    public virtual ICollection<OcjenaRestoran> OcjenaRestorans { get; set; } = new List<OcjenaRestoran>();

    public virtual ICollection<RestoranFavorit> RestoranFavorits { get; set; } = new List<RestoranFavorit>();

    public virtual ICollection<Restoran> Restorans { get; set; } = new List<Restoran>();

    public virtual ICollection<Upit> Upits { get; set; } = new List<Upit>();
}
