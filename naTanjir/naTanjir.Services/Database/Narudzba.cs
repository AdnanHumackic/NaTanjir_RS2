using System;
using System.Collections.Generic;

namespace naTanjir.Services.Database;

public partial class Narudzba:ISoftDelete
{
    public int NarudzbaId { get; set; }

    public int BrojNarudzbe { get; set; }

    public decimal UkupnaCijena { get; set; }

    public DateTime DatumKreiranja { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public string? StateMachine { get; set; }

    public bool IsDeleted { get; set; }

    public int KorisnikId { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual ICollection<StavkeNarudzbe> StavkeNarudzbes { get; set; } = new List<StavkeNarudzbe>();
}
