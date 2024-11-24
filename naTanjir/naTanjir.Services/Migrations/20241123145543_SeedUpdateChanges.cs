using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace naTanjir.Services.Migrations
{
    /// <inheritdoc />
    public partial class SeedUpdateChanges : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "8WAXrK//8uWDej4nxv4/S0GJ0Ro=", "3DlxCoNsjtCd3bM8hGtimg==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "8WAXrK//8uWDej4nxv4/S0GJ0Ro=", "3DlxCoNsjtCd3bM8hGtimg==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 3,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "8WAXrK//8uWDej4nxv4/S0GJ0Ro=", "3DlxCoNsjtCd3bM8hGtimg==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 4,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "8WAXrK//8uWDej4nxv4/S0GJ0Ro=", "3DlxCoNsjtCd3bM8hGtimg==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 5,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "8WAXrK//8uWDej4nxv4/S0GJ0Ro=", "3DlxCoNsjtCd3bM8hGtimg==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 6,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "8WAXrK//8uWDej4nxv4/S0GJ0Ro=", "3DlxCoNsjtCd3bM8hGtimg==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 7,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "8WAXrK//8uWDej4nxv4/S0GJ0Ro=", "3DlxCoNsjtCd3bM8hGtimg==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 8,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "8WAXrK//8uWDej4nxv4/S0GJ0Ro=", "3DlxCoNsjtCd3bM8hGtimg==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 9,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "8WAXrK//8uWDej4nxv4/S0GJ0Ro=", "3DlxCoNsjtCd3bM8hGtimg==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 10,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "8WAXrK//8uWDej4nxv4/S0GJ0Ro=", "3DlxCoNsjtCd3bM8hGtimg==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 11,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "8WAXrK//8uWDej4nxv4/S0GJ0Ro=", "3DlxCoNsjtCd3bM8hGtimg==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 12,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "8WAXrK//8uWDej4nxv4/S0GJ0Ro=", "3DlxCoNsjtCd3bM8hGtimg==" });

            migrationBuilder.UpdateData(
                table: "Narudzba",
                keyColumn: "NarudzbaID",
                keyValue: 1,
                column: "UkupnaCijena",
                value: 36m);

            migrationBuilder.UpdateData(
                table: "Narudzba",
                keyColumn: "NarudzbaID",
                keyValue: 2,
                column: "UkupnaCijena",
                value: 25m);

            migrationBuilder.UpdateData(
                table: "Narudzba",
                keyColumn: "NarudzbaID",
                keyValue: 3,
                column: "UkupnaCijena",
                value: 16m);

            migrationBuilder.UpdateData(
                table: "Narudzba",
                keyColumn: "NarudzbaID",
                keyValue: 4,
                column: "UkupnaCijena",
                value: 30m);

            migrationBuilder.UpdateData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 3,
                columns: new[] { "Cijena", "NarudzbaID", "ProizvodID", "RestoranID" },
                values: new object[] { 12m, 1, 3, 1 });

            migrationBuilder.UpdateData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 4,
                column: "ProizvodID",
                value: 7);

            migrationBuilder.UpdateData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 5,
                columns: new[] { "Cijena", "NarudzbaID", "ProizvodID", "RestoranID" },
                values: new object[] { 8m, 2, 8, 2 });

            migrationBuilder.UpdateData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 6,
                columns: new[] { "Cijena", "NarudzbaID", "ProizvodID", "RestoranID" },
                values: new object[] { 9m, 2, 12, 2 });

            migrationBuilder.UpdateData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 7,
                columns: new[] { "Cijena", "NarudzbaID", "ProizvodID", "RestoranID" },
                values: new object[] { 5m, 3, 14, 3 });

            migrationBuilder.UpdateData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 8,
                columns: new[] { "Cijena", "NarudzbaID", "ProizvodID", "RestoranID" },
                values: new object[] { 5m, 3, 15, 3 });

            migrationBuilder.InsertData(
                table: "StavkeNarudzbe",
                columns: new[] { "StavkeNarudzbeID", "Cijena", "IsDeleted", "Kolicina", "NarudzbaID", "ProizvodID", "RestoranID", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 9, 6m, false, 1, 3, 17, 3, null },
                    { 10, 6m, false, 1, 4, 20, 4, null },
                    { 11, 12m, false, 1, 4, 21, 4, null },
                    { 13, 12m, false, 1, 4, 24, 4, null }
                });

            migrationBuilder.UpdateData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 1,
                column: "Opis",
                value: "");

            migrationBuilder.UpdateData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 2,
                column: "Opis",
                value: "");

            migrationBuilder.UpdateData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 3,
                column: "Opis",
                value: "");

            migrationBuilder.UpdateData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 4,
                column: "Opis",
                value: "");

            migrationBuilder.UpdateData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 5,
                column: "Opis",
                value: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 13);

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 1,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "2pka8gGVbEqAsY4ijeBsTJehv9Y==", "dgCBLLURssjdW6U+61MC+Q==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 2,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 3,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "c1WzmHn/IfIrmkynZcsLyWHuzqE=", "dgCBLLURssjdW6U+61MC+Q==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 4,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "9MF7KTZlFft51eQvyTtlgmYQlOs=", "dgCBLLURssjdW6U+61MC+Q==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 5,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "aK8cml17lpwbriKaVDWacJdixas=", "dgCBLLURssjdW6U+61MC+Q==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 6,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 7,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 8,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 9,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 10,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 11,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==" });

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 12,
                columns: new[] { "LozinkaHash", "LozinkaSalt" },
                values: new object[] { "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=", "dgCBLLURssjdW6U+61MC+Q==" });

            migrationBuilder.UpdateData(
                table: "Narudzba",
                keyColumn: "NarudzbaID",
                keyValue: 1,
                column: "UkupnaCijena",
                value: 24m);

            migrationBuilder.UpdateData(
                table: "Narudzba",
                keyColumn: "NarudzbaID",
                keyValue: 2,
                column: "UkupnaCijena",
                value: 16m);

            migrationBuilder.UpdateData(
                table: "Narudzba",
                keyColumn: "NarudzbaID",
                keyValue: 3,
                column: "UkupnaCijena",
                value: 10m);

            migrationBuilder.UpdateData(
                table: "Narudzba",
                keyColumn: "NarudzbaID",
                keyValue: 4,
                column: "UkupnaCijena",
                value: 18m);

            migrationBuilder.UpdateData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 3,
                columns: new[] { "Cijena", "NarudzbaID", "ProizvodID", "RestoranID" },
                values: new object[] { 8m, 2, 7, 2 });

            migrationBuilder.UpdateData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 4,
                column: "ProizvodID",
                value: 8);

            migrationBuilder.UpdateData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 5,
                columns: new[] { "Cijena", "NarudzbaID", "ProizvodID", "RestoranID" },
                values: new object[] { 5m, 3, 14, 3 });

            migrationBuilder.UpdateData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 6,
                columns: new[] { "Cijena", "NarudzbaID", "ProizvodID", "RestoranID" },
                values: new object[] { 5m, 3, 15, 3 });

            migrationBuilder.UpdateData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 7,
                columns: new[] { "Cijena", "NarudzbaID", "ProizvodID", "RestoranID" },
                values: new object[] { 6m, 4, 20, 4 });

            migrationBuilder.UpdateData(
                table: "StavkeNarudzbe",
                keyColumn: "StavkeNarudzbeID",
                keyValue: 8,
                columns: new[] { "Cijena", "NarudzbaID", "ProizvodID", "RestoranID" },
                values: new object[] { 12m, 4, 21, 4 });

            migrationBuilder.UpdateData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 1,
                column: "Opis",
                value: null);

            migrationBuilder.UpdateData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 2,
                column: "Opis",
                value: null);

            migrationBuilder.UpdateData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 3,
                column: "Opis",
                value: null);

            migrationBuilder.UpdateData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 4,
                column: "Opis",
                value: null);

            migrationBuilder.UpdateData(
                table: "Uloge",
                keyColumn: "UlogaID",
                keyValue: 5,
                column: "Opis",
                value: null);
        }
    }
}
