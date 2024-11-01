using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model
{
    public class Narudzba
    {
        public int NarudzbaId { get; set; }

        public int BrojNarudzbe { get; set; }

        public decimal UkupnaCijena { get; set; }

        public DateTime DatumKreiranja { get; set; }
        public int KorisnikId { get; set; }
        public string? StateMachine { get; set; }
        public virtual Korisnici Korisnik { get; set; }
        public int DostavljacId {  get; set; }
        public virtual ICollection<StavkeNarudzbe> StavkeNarudzbes { get; set; } = new List<StavkeNarudzbe>();



    }
}
