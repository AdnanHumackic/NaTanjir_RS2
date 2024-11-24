using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace naTanjir.Services.Migrations
{
    /// <inheritdoc />
    public partial class SeedUpdateLokacija : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Lokacija",
                columns: new[] { "LokacijaID", "Adresa", "GeografskaDuzina", "GeografskaSirina", "IsDeleted", "KorisnikID", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, null, 17.8150160106649m, 43.3373771504426m, false, 1, null },
                    { 2, null, 17.8150160106649m, 43.3373771504426m, false, 2, null }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Lokacija",
                keyColumn: "LokacijaID",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Lokacija",
                keyColumn: "LokacijaID",
                keyValue: 2);
        }
    }
}
