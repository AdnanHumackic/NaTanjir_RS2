using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace naTanjir.Services.Migrations
{
    /// <inheritdoc />
    public partial class DataSeeding : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Korisnici",
                columns: new[] { "KorisnikID", "DatumRodjenja", "Email", "Ime", "IsDeleted", "KorisnickoIme", "LozinkaHash", "LozinkaSalt", "Prezime", "RestoranID", "Slika", "Telefon", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2004, 7, 20, 14, 48, 41, 913, DateTimeKind.Unspecified), "kupac@gmail.com", "Kupac", false, "kupac", "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==", "Tester", null, null, "+060303101", null },
                    { 2, new DateTime(2004, 7, 20, 14, 48, 41, 913, DateTimeKind.Unspecified), "kupac2@gmail.com", "Kupacdva", false, "kupac2", "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==", "Tester", null, null, "+060303101", null },
                    { 3, new DateTime(2004, 7, 20, 14, 48, 41, 913, DateTimeKind.Unspecified), "vlasnik@gmail.com", "Vlasnik", false, "vlasnik", "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==", "Tester", null, null, "+060303101", null },
                    { 4, new DateTime(2004, 7, 20, 14, 48, 41, 913, DateTimeKind.Unspecified), "admin@gmail.com", "Admin", false, "admin", "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==", "Tester", null, null, "+060303101", null }
                });

            migrationBuilder.InsertData(
                table: "Uloge",
                columns: new[] { "UlogaID", "IsDeleted", "Naziv", "Opis", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Kupac", null, null },
                    { 2, false, "Vlasnik", null, null },
                    { 3, false, "Admin", null, null },
                    { 4, false, "Dostavljac", null, null },
                    { 5, false, "RadnikRestorana", null, null }
                });

            migrationBuilder.InsertData(
                table: "VrstaProizvoda",
                columns: new[] { "VrstaID", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Pizza", null },
                    { 2, false, "Burger", null },
                    { 3, false, "Sendvić", null },
                    { 4, false, "Tjestenina", null },
                    { 5, false, "Salata", null },
                    { 6, false, "Desert", null },
                    { 7, false, "Pića", null },
                    { 8, false, "Piletina i meso", null },
                    { 9, false, "Sushi", null },
                    { 10, false, "Tacos", null },
                    { 11, false, "Burritos", null },
                    { 12, false, "Kineska kuhinja", null },
                    { 13, false, "Indijska kuhinja", null },
                    { 14, false, "Morski plodovi", null },
                    { 15, false, "Zdrava hrana", null },
                    { 16, false, "Vafli", null },
                    { 17, false, "Palaćinke", null },
                    { 18, false, "Pita", null },
                    { 19, false, "Peciva", null },
                    { 20, false, "Kafa", null }
                });

            migrationBuilder.InsertData(
                table: "VrstaRestorana",
                columns: new[] { "VrstaID", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Pizzeria", null },
                    { 2, false, "Italijanski restoran", null },
                    { 3, false, "Fast food", null },
                    { 4, false, "Buregžinica", null },
                    { 5, false, "Grill bar", null },
                    { 6, false, "Slastičarna", null },
                    { 7, false, "Meksički restoran", null },
                    { 8, false, "Indijski restoran", null },
                    { 9, false, "Ćevapdžinica", null },
                    { 10, false, "Palaćinkarnica", null },
                    { 11, false, "Sushi bar", null },
                    { 12, false, "Taco bar", null },
                    { 13, false, "Bistro", null },
                    { 14, false, "Tavern", null },
                    { 15, false, "Kafić sa slasticama", null }
                });

            migrationBuilder.InsertData(
                table: "KorisniciUloge",
                columns: new[] { "KorisnikUlogaID", "IsDeleted", "KorisnikID", "UlogaID", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, 1, 1, null },
                    { 2, false, 2, 1, null },
                    { 3, false, 3, 2, null },
                    { 4, false, 4, 3, null }
                });

            migrationBuilder.InsertData(
                table: "Narudzba",
                columns: new[] { "NarudzbaID", "BrojNarudzbe", "DatumKreiranja", "DostavljacID", "IsDeleted", "KorisnikID", "StateMachine", "UkupnaCijena", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 4324, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), null, false, 1, "kreirana", 24m, null },
                    { 2, 3042, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), null, false, 1, "kreirana", 16m, null },
                    { 3, 3042, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), null, false, 2, "kreirana", 10m, null },
                    { 4, 1092, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), null, false, 2, "kreirana", 18m, null }
                });

            migrationBuilder.InsertData(
                table: "Restoran",
                columns: new[] { "RestoranID", "IsDeleted", "Lokacija", "Naziv", "RadnoVrijemeDo", "RadnoVrijemeOd", "Slika", "StateMachine", "VlasnikID", "VrijemeBrisanja", "VrstaRestoranaID" },
                values: new object[,]
                {
                    { 1, false, "Branilaca Bosne bb, Blagaj", "Pizzeria Nerry", "22:00", "08:00", null, null, 3, null, 1 },
                    { 2, false, "Branilaca Bosne bb, Blagaj", "Restoran Čaršija", "22:00", "08:00", null, null, 3, null, 3 },
                    { 3, false, "Branilaca Bosne bb, Blagaj", "Slastičarna Ada", "22:00", "08:00", null, null, 3, null, 15 },
                    { 4, false, "Branilaca Bosne bb, Blagaj", "Restoran Royal", "22:00", "08:00", null, null, 3, null, 13 }
                });

            migrationBuilder.InsertData(
                table: "Korisnici",
                columns: new[] { "KorisnikID", "DatumRodjenja", "Email", "Ime", "IsDeleted", "KorisnickoIme", "LozinkaHash", "LozinkaSalt", "Prezime", "RestoranID", "Slika", "Telefon", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 5, new DateTime(2004, 7, 20, 14, 48, 41, 913, DateTimeKind.Unspecified), "dostavljac@gmail.com", "Dostavljac", false, "dostavljac", "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==", "Tester", 1, null, "+060303101", null },
                    { 6, new DateTime(2004, 7, 20, 14, 48, 41, 913, DateTimeKind.Unspecified), "dostavljac2@gmail.com", "Dostavljac", false, "dostavljac2", "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==", "Tester", 2, null, "+060303101", null },
                    { 7, new DateTime(2004, 7, 20, 14, 48, 41, 913, DateTimeKind.Unspecified), "dostavljac2@gmail.com", "Dostavljac", false, "dostavljac3", "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==", "Tester", 3, null, "+060303101", null },
                    { 8, new DateTime(2004, 7, 20, 14, 48, 41, 913, DateTimeKind.Unspecified), "dostavljac2@gmail.com", "Dostavljac", false, "dostavljac4", "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==", "Tester", 4, null, "+060303101", null },
                    { 9, new DateTime(2004, 7, 20, 14, 48, 41, 913, DateTimeKind.Unspecified), "radnikrestorana@gmail.com", "Radnikrestorana", false, "radnikrestorana", "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==", "Tester", 1, null, "+060303101", null },
                    { 10, new DateTime(2004, 7, 20, 14, 48, 41, 913, DateTimeKind.Unspecified), "radnikrestorana@gmail.com", "Radnikrestorana", false, "radnikrestorana2", "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==", "Tester", 2, null, "+060303101", null },
                    { 11, new DateTime(2004, 7, 20, 14, 48, 41, 913, DateTimeKind.Unspecified), "radnikrestorana@gmail.com", "Radnikrestorana", false, "radnikrestorana3", "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==", "Tester", 3, null, "+060303101", null },
                    { 12, new DateTime(2004, 7, 20, 14, 48, 41, 913, DateTimeKind.Unspecified), "radnikrestorana@gmail.com", "Radnikrestorana", false, "radnikrestorana4", "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==", "Tester", 4, null, "+060303101", null }
                });

            migrationBuilder.InsertData(
                table: "OcjenaRestoran",
                columns: new[] { "OcjenaRestoranID", "DatumKreiranja", "IsDeleted", "KorisnikID", "Ocjena", "RestoranID", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 4m, 1, null },
                    { 2, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 5m, 2, null },
                    { 3, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 3m, 3, null },
                    { 4, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 3m, 4, null },
                    { 5, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 5m, 1, null },
                    { 6, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 4m, 2, null },
                    { 7, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 3m, 3, null },
                    { 8, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 2m, 4, null }
                });

            migrationBuilder.InsertData(
                table: "Proizvod",
                columns: new[] { "ProizvodID", "Cijena", "IsDeleted", "Naziv", "Opis", "RestoranID", "Slika", "StateMachine", "VrijemeBrisanja", "VrstaProizvodaID" },
                values: new object[,]
                {
                    { 1, 12m, false, "Pizza Mexicana", "Pizza Mexicana u restoranu Pizzeria Nerry predstavlja savršenu harmoniju meksičkih i italijanskih okusa.\nPripremljena na savršeno tankom, hrskavom tijestu, ova pizza je prekrivena bogatim umakom od paradajza\n, začinjenim mljevenim mesom, slatkim kukuruzom, crvenim grahom i hrskavim papričicama.\nJalapeño paprike dodaju dozu pikantnosti koja budi sva čula, dok se otopljeni\n sloj mozzarelle brine za savršenu kremastost svakog zalogaja.", 1, null, null, null, 1 },
                    { 2, 12m, false, "Chicken Pizza", "Chicken pizza je savršena kombinacija sočnih komadića piletine, topljenog sira i ukusnog tijesta.\nObogaćena mješavinom začina i svježim povrćem, poput paprike i luka,\n ova pizza nudi bogat i ukusan obrok idealan za ljubitelje piletine i klasičnih pizza okusa.", 1, null, null, null, 1 },
                    { 3, 12m, false, "Pizza Margherita", "Pizza Margherita je klasična italijanska pizza koja osvaja svojom jednostavnošću i savršenim balansom okusa.\nPriprema se od svježeg tijesta, premazana umakom od zrelih paradajza, posuta topljenim mozzarella sirom i aromatičnim listovima svježeg bosiljka.\nOvo jelo simbolizira autentičnost i tradiciju italijanske kuhinje.", 1, null, null, null, 1 },
                    { 4, 11m, false, "Pizza capricciosa", "Pizza Capricciosa je bogata i raznovrsna pizza koja spaja najukusnije sastojke.\nKlasično tijesto premazano je umakom od paradajza\n i posuto topljenim mozzarella sirom, uz dodatak šunke, svježih šampinjona, maslina i artičoka.\nSvaki zalogaj pruža savršenu harmoniju okusa, idealnu za ljubitelje bogatijih i tradicionalnih pizza.", 1, null, null, null, 1 },
                    { 5, 10m, false, "Pizza Quattro Formaggi", "Pizza Quattro Formaggi je pravi raj za ljubitelje sira. Priprema se na klasičnom tijestu\n, premazanom tankim slojem umaka od paradajza (ili bez njega, u bijeloj verziji) te obilno posutom kombinacijom\n četiri vrste sira: mozzarella, gorgonzola, parmezan i ricotta.\nSvaka vrsta sira doprinosi bogatstvu i kremastoj teksturi, stvarajući intenzivan i nezaboravan okus.", 1, null, null, null, 1 },
                    { 6, 10m, false, "Pizza Diavola ", "Pizza Diavola je prava poslastica za ljubitelje začinjenih jela. \nNa hrskavom tijestu nalazi se bogat sloj umaka od paradajza, topila mozzarella i obilje ljutih sastojaka poput pikantne salame,\n crvenih paprika i maslina. Ova pizza pruža savršen balans između ljutine i bogatog okusa,\n idealna za one koji vole uživati u intenzivnim i začinjenim jelima.", 1, null, null, null, 1 },
                    { 7, 8m, false, "Burger Classic", "Burger Classic je jednostavan, ali ukusan izbor za sve ljubitelje klasičnih burgera.\nSastoji se od sočne pljeskavice od mljevene govedine, koja je savršeno pečena i poslužen je u mekanom pecivu.\nDodaju se svježi sastojci poput zelene salate, rajčice, kiselih krastavaca i luka, te se sve začini s majonezom, senfom ili kečapom po želji.\nOvaj burger nudi savršen spoj okusa, s bogatim mesom i svježim povrćem, idealan za ljubitelje jednostavnih i kvalitetnih jela.", 2, null, null, null, 2 },
                    { 8, 8m, false, "Cheeseburger", "Cheeseburger je savršen izbor za ljubitelje sira. Sastoji se od sočne goveđe pljeskavice na kojoj se topi\n sloj rastopljenog cheddar sira. Uz to, u mekanom pecivu dolaze svježi krastavci, rajčica, zelena salata i luk,\n s dodatkom umaka po izboru (majoneza, kečap ili senf). Ovaj burger pruža bogatstvo okusa s kombinacijom sira, mesa i povrća,\n pružajući savršeno zadovoljstvo za svakog ljubitelja klasične kombinacije.", 2, null, null, null, 2 },
                    { 9, 10m, false, "BBQ Burger", "BBQ Burger je pravi izbor za ljubitelje dimljenih i slatko-ljutih okusa.\nSastoji se od sočne goveđe pljeskavice, na kojoj je sloj topljenog cheddar sira, a cijeli burger je premazan bogatim\nBBQ umakom koji mu daje specifičan dimljeni okus. Uz to, dodaju se kriške svježeg luka, kiselih krastavaca i hrskava slanina, sve u mekanom pecivu.\nOvaj burger nudi kombinaciju slatko-dimljenih okusa s hrskavim teksturama, idealan za sve koji uživaju u bogatim, intenzivnim jelima.", 2, null, null, null, 2 },
                    { 10, 10m, false, "Mushroom Swiss Burger", "Mushroom Swiss Burger je delikatan burger za ljubitelje gljiva i sira.\nSočna goveđa pljeskavica prekrivena je slojem rastopljenog švicarskog sira i pečenim gljivama,\n koje dodaju bogatstvo okusa i aromu.Uz to, dolaze svježi krastavci, rajčica i povrće po izboru, sve smješteno u mekanom pecivu.\nOvaj burger je savršen spoj umami okusa i svježih sastojaka, idealan za one koji traže sofisticiraniju verziju klasičnog burgera.", 2, null, null, null, 2 },
                    { 11, 6m, false, "Club Sandwich", "Club sandwich je klasični sendvič koji nudi savršen spoj okusa i tekstura.\nSastoji se od tri sloja svježeg bijelog kruha, svaki prepun bogatog nadeva od pečene piletine, hrskave slanine, svježih rajčica,\n zelene salate i majoneze. Ovaj sendvič nudi bogatstvo okusa, od sočne piletine i hrskave slanine do osvježavajuće salate i rajčica,\n sve to upotpunjeno kremastim majonezom. Savršen je izbor za sve koji žele uživati u klasičnom, ali ukusnom sendviču.", 2, null, null, null, 3 },
                    { 12, 9m, false, "Tuna Salad Sandwich", "Tuna salad sandwich je lagan i ukusan sendvič koji je savršen za ljubitelje tune. \nOvaj sendvič sadrži kremastu salatu od tune,\n pomiješanu s majonezom, senfom i začinima, uz svježe povrće poput luka, krastavaca i rajčica. Sve je smješteno između dva komada\n mekanog integralnog ili bijelog kruha. Ovaj sendvič nudi jednostavan, ali bogat okus, s savršenom ravnotežom\n između sočne tune i svježeg povrća.", 2, null, null, null, 3 },
                    { 13, 4m, false, "Čokoladni Brownie", "Brownie je sočan, gust i bogat čokoladni kolač, obično s komadićima tamne čokolade\n ili čokoladnim komadićima u tijestu. Njegova tekstura je između biskvita i fudgy smjese, s hrskavom koricom\n i sočnim srednjim dijelom. Savršen je za ljubitelje tamne čokolade.", 3, null, null, null, 6 },
                    { 14, 5m, false, "Vanilija Cupcake", "Vanilija cupcake je lagani, mekani kolač s predivnim vanilija okusom. Obično je prekriven šarenom\n glazurom od maslaca, uz dodatak dekoracija poput šarenih mrvica ili jestivih cvjetova. Ovaj kolač je savršen\n za sve prigode, od rođendanskih zabava do opuštenih popodneva s prijateljima.", 3, null, null, null, 6 },
                    { 15, 5m, false, "Kolač od Limuna i Poppy Seeds (Mak)", "Ovaj kolač nudi savršenu ravnotežu svježeg okusa limuna i blagih, hrskavih sjemenki maka.\nLagano je vlažan, a nježna tekstura čini ga savršenim za uživanje uz čaj ili kavu.\nSvježina limuna i mala količina maka daju ovom kolaču jedinstvenu aromu i boju.", 3, null, null, null, 6 },
                    { 16, 5m, false, "Palačinke sa Nutellom", "Klasične tanke palačinke prekrivene bogatom Nutellom, čokoladnom kremom koja je omiljena među ljubiteljima slatkog.\nNutella se jednostavno nanosi na još tople palačinke, a često se dodaju i kesten pire, šlag ili komadići voća poput banana za dodatni okus.", 3, null, null, null, 6 },
                    { 17, 6m, false, "Palačinke sa Jagodama i Šlagom", "Palačinke punjene svježim jagodama i prelivene šlagom. Ovaj jednostavan, ali ukusan desert donosi \nsavršenu ravnotežu između kiselkaste svježine jagoda i slatkog šlaga, stvarajući laganu\n i osvježavajuću poslasticu, idealnu za ljetne dane.", 3, null, null, null, 6 },
                    { 18, 6m, false, "Palačinke sa Nutellom i Banama", "Jednostavne palačinke sa kremom od Nutelle, dodatno obogaćene svježim kolutićima banana.\nOva kombinacija čokolade i voća stvara savršen balans slatkog i voćnog okusa, a često se poslužuje\n i sa malo grčkog jogurta ili šlaga za kremastu teksturu.", 3, null, null, null, 6 },
                    { 19, 6m, false, "Quiche", "Kremasti kolač od prhkog tijesta, obično punjen sa kombinacijom jaja, vrhnja, sira i povrća ili mesa.\n Popularni su quiche sa špinatom, slaninom ili gljivama.", 4, null, null, null, 6 },
                    { 20, 6m, false, "Croque Monsieur", "Francuski sendvič od toasta sa šunkom i sirom, preliven bešamel \nsosom i zapečen u pećnici do zlatne boje.", 4, null, null, null, 3 },
                    { 21, 12m, false, "Ratatouille", "Klasično francusko jelo od povrća (patlidžan, tikvice, paprika, paradajz i luk), kuhano sa maslinovim uljemn i začinskim biljem. Lagano, zdravo i puno okusa.", 4, null, null, null, 15 },
                    { 22, 14m, false, "Steak Frites", "Jednostavan, ali ukusan obrok: sočni odrezak (obično od goveđeg mesa) poslužuje se sa prženim pomfritima, često uz neki umak poput umaka od crnog vina ili beurre maître d'hôtel.", 4, null, null, null, 8 },
                    { 23, 10m, false, "Salata Niçoise", "Francuska salata koja uključuje paradajz, krastavce, crne masline, \nzelenu salatu i kuhane krumpire, obično začinjenu sa maslinovim uljem i balzamičnim octom.", 4, null, null, null, 15 },
                    { 24, 12m, false, "Quiche Lorraine", "Quiche Lorraine je klasično francusko jelo koje potiče iz Lorraine regije, a danas je \npopularno širom sveta. Osim pancete, u receptu se često mogu dodati i druge sastojke poput sira,\n luka ili povrća, zavisno od varijacije.", 4, null, null, null, 18 }
                });

            migrationBuilder.InsertData(
                table: "RestoranFavorit",
                columns: new[] { "RestoranFavoritID", "DatumDodavanja", "IsDeleted", "KorisnikID", "RestoranID", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 1, null },
                    { 2, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 2, null },
                    { 3, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 3, null },
                    { 4, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 4, null }
                });

            migrationBuilder.InsertData(
                table: "KorisniciUloge",
                columns: new[] { "KorisnikUlogaID", "IsDeleted", "KorisnikID", "UlogaID", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 5, false, 5, 4, null },
                    { 6, false, 6, 4, null },
                    { 7, false, 7, 4, null },
                    { 8, false, 8, 4, null },
                    { 9, false, 9, 5, null },
                    { 10, false, 10, 5, null },
                    { 11, false, 11, 5, null },
                    { 12, false, 12, 5, null }
                });

            migrationBuilder.InsertData(
                table: "OcjenaProizvod",
                columns: new[] { "OcjenaProizvodID", "DatumKreiranja", "IsDeleted", "KorisnikID", "Ocjena", "ProizvodID", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 4m, 1, null },
                    { 2, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 3m, 2, null },
                    { 3, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 4m, 3, null },
                    { 4, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 3m, 7, null },
                    { 5, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 5m, 8, null },
                    { 6, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 3m, 9, null },
                    { 7, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 3m, 13, null },
                    { 8, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 3m, 14, null },
                    { 9, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 4m, 15, null },
                    { 10, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 4m, 19, null },
                    { 11, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 2m, 20, null },
                    { 12, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 1, 3m, 21, null },
                    { 13, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 4m, 4, null },
                    { 14, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 3m, 5, null },
                    { 15, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 4m, 6, null },
                    { 16, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 3m, 10, null },
                    { 17, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 5m, 11, null },
                    { 18, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 3m, 12, null },
                    { 19, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 3m, 16, null },
                    { 20, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 3m, 17, null },
                    { 21, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 4m, 18, null },
                    { 22, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 4m, 22, null },
                    { 23, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 2m, 23, null },
                    { 24, new DateTime(2024, 8, 11, 15, 45, 20, 837, DateTimeKind.Unspecified), false, 2, 3m, 24, null }
                });

            migrationBuilder.InsertData(
                table: "StavkeNarudzbe",
                columns: new[] { "StavkeNarudzbeID", "Cijena", "IsDeleted", "Kolicina", "NarudzbaID", "ProizvodID", "RestoranID", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 12m, false, 1, 1, 1, 1, null },
                    { 2, 12m, false, 1, 1, 2, 1, null },
                    { 3, 8m, false, 1, 2, 7, 2, null },
                    { 4, 8m, false, 1, 2, 8, 2, null },
                    { 5, 5m, false, 1, 3, 14, 3, null },
                    { 6, 5m, false, 1, 3, 15, 3, null },
                    { 7, 6m, false, 1, 4, 20, 4, null },
                    { 8, 12m, false, 1, 4, 21, 4, null }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaID",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaID",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaID",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaID",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaID",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "KorisniciUloge",
                keyColumn: "KorisnikUlogaID",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "OcjenaProizvod",
                keyColumn: "OcjenaProizvodID",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "OcjenaRestoran",
                keyColumn: "OcjenaRestoranID",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "OcjenaRestoran",
                keyColumn: "OcjenaRestoranID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "OcjenaRestoran",
                keyColumn: "OcjenaRestoranID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "OcjenaRestoran",
                keyColumn: "OcjenaRestoranID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "OcjenaRestoran",
                keyColumn: "OcjenaRestoranID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "OcjenaRestoran",
                keyColumn: "OcjenaRestoranID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "OcjenaRestoran",
                keyColumn: "OcjenaRestoranID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "OcjenaRestoran",
                keyColumn: "OcjenaRestoranID",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "RestoranFavorit",
                keyColumn: "RestoranFavoritID",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "RestoranFavorit",
                keyColumn: "RestoranFavoritID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "RestoranFavorit",
                keyColumn: "RestoranFavoritID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "RestoranFavorit",
                keyColumn: "RestoranFavoritID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaID",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "Proizvod",
                keyColumn: "ProizvodID",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Restoran",
                keyColumn: "RestoranID",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Restoran",
                keyColumn: "RestoranID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Restoran",
                keyColumn: "RestoranID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Restoran",
                keyColumn: "RestoranID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "VrstaProizvoda",
                keyColumn: "VrstaID",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "VrstaRestorana",
                keyColumn: "VrstaID",
                keyValue: 15);
        }
    }
}
