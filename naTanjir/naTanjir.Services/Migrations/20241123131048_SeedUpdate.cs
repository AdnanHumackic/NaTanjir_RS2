using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace naTanjir.Services.Migrations
{
    /// <inheritdoc />
    public partial class SeedUpdate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 1,
                column: "LozinkaHash",
                value: "2pka8gGVbEqAsY4ijeBsTJehv9Y==");

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 3,
                column: "LozinkaHash",
                value: "c1WzmHn/IfIrmkynZcsLyWHuzqE=");

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 4,
                column: "LozinkaHash",
                value: "9MF7KTZlFft51eQvyTtlgmYQlOs=");

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 5,
                column: "LozinkaHash",
                value: "aK8cml17lpwbriKaVDWacJdixas=");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 1,
                column: "LozinkaHash",
                value: "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=");

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 3,
                column: "LozinkaHash",
                value: "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=");

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 4,
                column: "LozinkaHash",
                value: "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=");

            migrationBuilder.UpdateData(
                table: "Korisnici",
                keyColumn: "KorisnikID",
                keyValue: 5,
                column: "LozinkaHash",
                value: "lUm1ZkjJ+8kF1mKNyCNUZToua6Y=");
        }
    }
}
