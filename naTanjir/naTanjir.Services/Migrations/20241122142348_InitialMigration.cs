using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace naTanjir.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitialMigration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Uloge",
                columns: table => new
                {
                    UlogaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Opis = table.Column<string>(type: "varchar(200)", unicode: false, maxLength: 200, nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Uloge__DCAB23EB1F3E7E4E", x => x.UlogaID);
                });

            migrationBuilder.CreateTable(
                name: "VrstaProizvoda",
                columns: table => new
                {
                    VrstaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__VrstaPro__42CB8F0F6A7204B9", x => x.VrstaID);
                });

            migrationBuilder.CreateTable(
                name: "VrstaRestorana",
                columns: table => new
                {
                    VrstaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__VrstaRes__42CB8F0FBB2B54F9", x => x.VrstaID);
                });

            migrationBuilder.CreateTable(
                name: "Korisnici",
                columns: table => new
                {
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Prezime = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Telefon = table.Column<string>(type: "varchar(20)", unicode: false, maxLength: 20, nullable: false),
                    KorisnickoIme = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    LozinkaHash = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    LozinkaSalt = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    DatumRodjenja = table.Column<DateTime>(type: "date", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "date", nullable: true),
                    RestoranID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Korisnic__80B06D6177EE62B8", x => x.KorisnikID);
                });

            migrationBuilder.CreateTable(
                name: "KorisniciUloge",
                columns: table => new
                {
                    KorisnikUlogaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    UlogaID = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "date", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Korisnic__1608720E8E1E1CAC", x => x.KorisnikUlogaID);
                    table.ForeignKey(
                        name: "FKKorisniciU569655",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FKKorisniciU863332",
                        column: x => x.UlogaID,
                        principalTable: "Uloge",
                        principalColumn: "UlogaID");
                });

            migrationBuilder.CreateTable(
                name: "Lokacija",
                columns: table => new
                {
                    LokacijaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Adresa = table.Column<string>(type: "varchar(255)", unicode: false, maxLength: 255, nullable: true),
                    GeografskaDuzina = table.Column<decimal>(type: "decimal(18,16)", nullable: true),
                    GeografskaSirina = table.Column<decimal>(type: "decimal(18,16)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "date", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Lokacija__49DE2C2AF537B551", x => x.LokacijaID);
                    table.ForeignKey(
                        name: "FKLokacija556795",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Narudzba",
                columns: table => new
                {
                    NarudzbaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    BrojNarudzbe = table.Column<int>(type: "int", nullable: false),
                    UkupnaCijena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "date", nullable: true),
                    StateMachine = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    DostavljacID = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Narudzba__FBEC1357883C3095", x => x.NarudzbaID);
                    table.ForeignKey(
                        name: "FKNarudzba82867",
                        column: x => x.DostavljacID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FKNarudzba980749",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "Restoran",
                columns: table => new
                {
                    RestoranID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    RadnoVrijemeOd = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    RadnoVrijemeDo = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    Lokacija = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "date", nullable: true),
                    StateMachine = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    VrstaRestoranaID = table.Column<int>(type: "int", nullable: false),
                    VlasnikID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Restoran__259AB1A74431504F", x => x.RestoranID);
                    table.ForeignKey(
                        name: "FKRestoran332334",
                        column: x => x.VlasnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FKRestoran645673",
                        column: x => x.VrstaRestoranaID,
                        principalTable: "VrstaRestorana",
                        principalColumn: "VrstaID");
                });

            migrationBuilder.CreateTable(
                name: "OcjenaRestoran",
                columns: table => new
                {
                    OcjenaRestoranID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DatumKreiranja = table.Column<DateTime>(type: "date", nullable: false),
                    Ocjena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "date", nullable: true),
                    RestoranID = table.Column<int>(type: "int", nullable: false),
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__OcjenaRe__993C51F773C6400A", x => x.OcjenaRestoranID);
                    table.ForeignKey(
                        name: "FKOcjenaRest861405",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FKOcjenaRest897301",
                        column: x => x.RestoranID,
                        principalTable: "Restoran",
                        principalColumn: "RestoranID");
                });

            migrationBuilder.CreateTable(
                name: "Proizvod",
                columns: table => new
                {
                    ProizvodID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "varchar(50)", unicode: false, maxLength: 50, nullable: false),
                    Cijena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Opis = table.Column<string>(type: "varchar(max)", unicode: false, nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "date", nullable: true),
                    StateMachine = table.Column<string>(type: "varchar(100)", unicode: false, maxLength: 100, nullable: true),
                    VrstaProizvodaID = table.Column<int>(type: "int", nullable: false),
                    RestoranID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Proizvod__21A8BE181053462D", x => x.ProizvodID);
                    table.ForeignKey(
                        name: "FKProizvod214927",
                        column: x => x.VrstaProizvodaID,
                        principalTable: "VrstaProizvoda",
                        principalColumn: "VrstaID");
                    table.ForeignKey(
                        name: "FKProizvod765485",
                        column: x => x.RestoranID,
                        principalTable: "Restoran",
                        principalColumn: "RestoranID");
                });

            migrationBuilder.CreateTable(
                name: "RestoranFavorit",
                columns: table => new
                {
                    RestoranFavoritID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DatumDodavanja = table.Column<DateTime>(type: "date", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "date", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    RestoranID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Restoran__2953C4B456B4BC39", x => x.RestoranFavoritID);
                    table.ForeignKey(
                        name: "FKRestoranFa114950",
                        column: x => x.RestoranID,
                        principalTable: "Restoran",
                        principalColumn: "RestoranID");
                    table.ForeignKey(
                        name: "FKRestoranFa643757",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                });

            migrationBuilder.CreateTable(
                name: "OcjenaProizvod",
                columns: table => new
                {
                    OcjenaProizvodID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DatumKreiranja = table.Column<DateTime>(type: "date", nullable: false),
                    Ocjena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "date", nullable: true),
                    ProizvodID = table.Column<int>(type: "int", nullable: false),
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__OcjenaPr__B0C8530F9F9D1878", x => x.OcjenaProizvodID);
                    table.ForeignKey(
                        name: "FKOcjenaProi212843",
                        column: x => x.KorisnikID,
                        principalTable: "Korisnici",
                        principalColumn: "KorisnikID");
                    table.ForeignKey(
                        name: "FKOcjenaProi294356",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvod",
                        principalColumn: "ProizvodID");
                });

            migrationBuilder.CreateTable(
                name: "StavkeNarudzbe",
                columns: table => new
                {
                    StavkeNarudzbeID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Kolicina = table.Column<int>(type: "int", nullable: false),
                    Cijena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "date", nullable: true),
                    NarudzbaID = table.Column<int>(type: "int", nullable: true),
                    ProizvodID = table.Column<int>(type: "int", nullable: false),
                    RestoranID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__StavkeNa__FA672E98C956CF71", x => x.StavkeNarudzbeID);
                    table.ForeignKey(
                        name: "FKStavkeNaru240217",
                        column: x => x.NarudzbaID,
                        principalTable: "Narudzba",
                        principalColumn: "NarudzbaID");
                    table.ForeignKey(
                        name: "FKStavkeNaru313239",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvod",
                        principalColumn: "ProizvodID");
                    table.ForeignKey(
                        name: "FKStavkeNaru909859",
                        column: x => x.RestoranID,
                        principalTable: "Restoran",
                        principalColumn: "RestoranID");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Korisnici_RestoranID",
                table: "Korisnici",
                column: "RestoranID");

            migrationBuilder.CreateIndex(
                name: "IX_KorisniciUloge_KorisnikID",
                table: "KorisniciUloge",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_KorisniciUloge_UlogaID",
                table: "KorisniciUloge",
                column: "UlogaID");

            migrationBuilder.CreateIndex(
                name: "IX_Lokacija_KorisnikID",
                table: "Lokacija",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Narudzba_DostavljacID",
                table: "Narudzba",
                column: "DostavljacID");

            migrationBuilder.CreateIndex(
                name: "IX_Narudzba_KorisnikID",
                table: "Narudzba",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_OcjenaProizvod_KorisnikID",
                table: "OcjenaProizvod",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_OcjenaProizvod_ProizvodID",
                table: "OcjenaProizvod",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_OcjenaRestoran_KorisnikID",
                table: "OcjenaRestoran",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_OcjenaRestoran_RestoranID",
                table: "OcjenaRestoran",
                column: "RestoranID");

            migrationBuilder.CreateIndex(
                name: "IX_Proizvod_RestoranID",
                table: "Proizvod",
                column: "RestoranID");

            migrationBuilder.CreateIndex(
                name: "IX_Proizvod_VrstaProizvodaID",
                table: "Proizvod",
                column: "VrstaProizvodaID");

            migrationBuilder.CreateIndex(
                name: "IX_Restoran_VlasnikID",
                table: "Restoran",
                column: "VlasnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Restoran_VrstaRestoranaID",
                table: "Restoran",
                column: "VrstaRestoranaID");

            migrationBuilder.CreateIndex(
                name: "IX_RestoranFavorit_KorisnikID",
                table: "RestoranFavorit",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_RestoranFavorit_RestoranID",
                table: "RestoranFavorit",
                column: "RestoranID");

            migrationBuilder.CreateIndex(
                name: "IX_StavkeNarudzbe_NarudzbaID",
                table: "StavkeNarudzbe",
                column: "NarudzbaID");

            migrationBuilder.CreateIndex(
                name: "IX_StavkeNarudzbe_ProizvodID",
                table: "StavkeNarudzbe",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_StavkeNarudzbe_RestoranID",
                table: "StavkeNarudzbe",
                column: "RestoranID");

            migrationBuilder.AddForeignKey(
                name: "FKKorisnici730368",
                table: "Korisnici",
                column: "RestoranID",
                principalTable: "Restoran",
                principalColumn: "RestoranID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FKKorisnici730368",
                table: "Korisnici");

            migrationBuilder.DropTable(
                name: "KorisniciUloge");

            migrationBuilder.DropTable(
                name: "Lokacija");

            migrationBuilder.DropTable(
                name: "OcjenaProizvod");

            migrationBuilder.DropTable(
                name: "OcjenaRestoran");

            migrationBuilder.DropTable(
                name: "RestoranFavorit");

            migrationBuilder.DropTable(
                name: "StavkeNarudzbe");

            migrationBuilder.DropTable(
                name: "Uloge");

            migrationBuilder.DropTable(
                name: "Narudzba");

            migrationBuilder.DropTable(
                name: "Proizvod");

            migrationBuilder.DropTable(
                name: "VrstaProizvoda");

            migrationBuilder.DropTable(
                name: "Restoran");

            migrationBuilder.DropTable(
                name: "Korisnici");

            migrationBuilder.DropTable(
                name: "VrstaRestorana");
        }
    }
}
