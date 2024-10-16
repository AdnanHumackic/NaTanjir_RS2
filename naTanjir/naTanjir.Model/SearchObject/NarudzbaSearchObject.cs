using System;
using System.Collections.Generic;
using System.Text;

namespace naTanjir.Model.SearchObject
{
    public class NarudzbaSearchObject:BaseSearchObject
    {
        public int? BrojNarudzbe { get; set; }
        public decimal? UkupnaCijena { get; set; }
        public DateTime? DatumKreiranja { get; set; }
        public DateTime? DatumKreiranjaGTE { get; set; }
        public DateTime? DatumKreiranjaLTE { get; set; }
        public string? StateMachine { get; set; }
        public int? KorisnikId { get; set; }
        public int? RestoranId { get; set; }
        public bool? IsStavkeNarudzbeIncluded { get; set; }
        public bool? IsKorisnikIncluded { get; set; }
        public bool? IsDeleted { get; set; }
    }
}
