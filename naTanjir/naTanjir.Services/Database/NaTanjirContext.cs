using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace naTanjir.Services.Database;

public partial class NaTanjirContext : DbContext
{
    public NaTanjirContext()
    {
    }

    public NaTanjirContext(DbContextOptions<NaTanjirContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Korisnici> Korisnicis { get; set; }

    public virtual DbSet<KorisniciUloge> KorisniciUloges { get; set; }

    public virtual DbSet<Lokacija> Lokacijas { get; set; }

    public virtual DbSet<Narudzba> Narudzbas { get; set; }

    public virtual DbSet<OcjenaProizvod> OcjenaProizvods { get; set; }

    public virtual DbSet<OcjenaRestoran> OcjenaRestorans { get; set; }

    public virtual DbSet<Proizvod> Proizvods { get; set; }

    public virtual DbSet<Restoran> Restorans { get; set; }

    public virtual DbSet<RestoranFavorit> RestoranFavorits { get; set; }

    public virtual DbSet<StavkeNarudzbe> StavkeNarudzbes { get; set; }

    public virtual DbSet<Uloge> Uloges { get; set; }

    public virtual DbSet<VrstaProizvodum> VrstaProizvoda { get; set; }

    public virtual DbSet<VrstaRestorana> VrstaRestoranas { get; set; }

//    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
//#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
//        => optionsBuilder.UseSqlServer("Data Source=localhost, 1433;Initial Catalog=naTanjir;user=sa;Password=QWEasd123!;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Korisnici>(entity =>
        {
            entity.HasKey(e => e.KorisnikId).HasName("PK__Korisnic__80B06D6177EE62B8");

            entity.ToTable("Korisnici");

            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.DatumRodjenja).HasColumnType("date");
            entity.Property(e => e.Email)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Ime)
                .HasMaxLength(50)
                .IsUnicode(true);
            entity.Property(e => e.KorisnickoIme)
                .HasMaxLength(50)
                .IsUnicode(true);
            entity.Property(e => e.LozinkaHash)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.LozinkaSalt)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Prezime)
                .HasMaxLength(50)
                .IsUnicode(true);
            entity.Property(e => e.RestoranId).HasColumnName("RestoranID");
            entity.Property(e => e.Telefon)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");

            entity.HasOne(d => d.Restoran).WithMany(p => p.Korisnicis)
                .HasForeignKey(d => d.RestoranId)
                .HasConstraintName("FKKorisnici730368");
        });

        modelBuilder.Entity<KorisniciUloge>(entity =>
        {
            entity.HasKey(e => e.KorisnikUlogaId).HasName("PK__Korisnic__1608720E8E1E1CAC");

            entity.ToTable("KorisniciUloge");

            entity.Property(e => e.KorisnikUlogaId).HasColumnName("KorisnikUlogaID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.UlogaId).HasColumnName("UlogaID");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.KorisniciUloges)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKorisniciU569655");

            entity.HasOne(d => d.Uloga).WithMany(p => p.KorisniciUloges)
                .HasForeignKey(d => d.UlogaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKKorisniciU863332");
        });

        modelBuilder.Entity<Lokacija>(entity =>
        {
            entity.HasKey(e => e.LokacijaId).HasName("PK__Lokacija__49DE2C2AF537B551");

            entity.ToTable("Lokacija");

            entity.Property(e => e.LokacijaId).HasColumnName("LokacijaID");
            entity.Property(e => e.Adresa)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.GeografskaDuzina).HasColumnType("decimal(18, 16)");
            entity.Property(e => e.GeografskaSirina).HasColumnType("decimal(18, 16)");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Lokacijas)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FKLokacija556795");
        });

        modelBuilder.Entity<Narudzba>(entity =>
        {
            entity.HasKey(e => e.NarudzbaId).HasName("PK__Narudzba__FBEC1357883C3095");

            entity.ToTable("Narudzba");

            entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");
            entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");
            entity.Property(e => e.DostavljacId).HasColumnName("DostavljacID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.StateMachine)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UkupnaCijena).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");

            entity.HasOne(d => d.Dostavljac).WithMany(p => p.NarudzbaDostavljacs)
                .HasForeignKey(d => d.DostavljacId)
                .HasConstraintName("FKNarudzba82867");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.NarudzbaKorisniks)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKNarudzba980749");
        });

        modelBuilder.Entity<OcjenaProizvod>(entity =>
        {
            entity.HasKey(e => e.OcjenaProizvodId).HasName("PK__OcjenaPr__B0C8530F9F9D1878");

            entity.ToTable("OcjenaProizvod");

            entity.Property(e => e.OcjenaProizvodId).HasColumnName("OcjenaProizvodID");
            entity.Property(e => e.DatumKreiranja).HasColumnType("date");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Ocjena).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.OcjenaProizvods)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOcjenaProi212843");

            entity.HasOne(d => d.Proizvod).WithMany(p => p.OcjenaProizvods)
                .HasForeignKey(d => d.ProizvodId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOcjenaProi294356");
        });

        modelBuilder.Entity<OcjenaRestoran>(entity =>
        {
            entity.HasKey(e => e.OcjenaRestoranId).HasName("PK__OcjenaRe__993C51F773C6400A");

            entity.ToTable("OcjenaRestoran");

            entity.Property(e => e.OcjenaRestoranId).HasColumnName("OcjenaRestoranID");
            entity.Property(e => e.DatumKreiranja).HasColumnType("date");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Ocjena).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.RestoranId).HasColumnName("RestoranID");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.OcjenaRestorans)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOcjenaRest861405");

            entity.HasOne(d => d.Restoran).WithMany(p => p.OcjenaRestorans)
                .HasForeignKey(d => d.RestoranId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKOcjenaRest897301");
        });

        modelBuilder.Entity<Proizvod>(entity =>
        {
            entity.HasKey(e => e.ProizvodId).HasName("PK__Proizvod__21A8BE181053462D");

            entity.ToTable("Proizvod");

            entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");
            entity.Property(e => e.Cijena).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(true);
            entity.Property(e => e.Opis).IsUnicode(false);
            entity.Property(e => e.RestoranId).HasColumnName("RestoranID");
            entity.Property(e => e.StateMachine)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");
            entity.Property(e => e.VrstaProizvodaId).HasColumnName("VrstaProizvodaID");

            entity.HasOne(d => d.Restoran).WithMany(p => p.Proizvods)
                .HasForeignKey(d => d.RestoranId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKProizvod765485");

            entity.HasOne(d => d.VrstaProizvoda).WithMany(p => p.Proizvods)
                .HasForeignKey(d => d.VrstaProizvodaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKProizvod214927");
        });

        modelBuilder.Entity<Restoran>(entity =>
        {
            entity.HasKey(e => e.RestoranId).HasName("PK__Restoran__259AB1A74431504F");

            entity.ToTable("Restoran");

            entity.Property(e => e.RestoranId).HasColumnName("RestoranID");
            entity.Property(e => e.Lokacija)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.RadnoVrijemeDo)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.RadnoVrijemeOd)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.StateMachine)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.VlasnikId).HasColumnName("VlasnikID");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");
            entity.Property(e => e.VrstaRestoranaId).HasColumnName("VrstaRestoranaID");

            entity.HasOne(d => d.Vlasnik).WithMany(p => p.Restorans)
                .HasForeignKey(d => d.VlasnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRestoran332334");

            entity.HasOne(d => d.VrstaRestorana).WithMany(p => p.Restorans)
                .HasForeignKey(d => d.VrstaRestoranaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRestoran645673");
        });

        modelBuilder.Entity<RestoranFavorit>(entity =>
        {
            entity.HasKey(e => e.RestoranFavoritId).HasName("PK__Restoran__2953C4B456B4BC39");

            entity.ToTable("RestoranFavorit");

            entity.Property(e => e.RestoranFavoritId).HasColumnName("RestoranFavoritID");
            entity.Property(e => e.DatumDodavanja).HasColumnType("date");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.RestoranId).HasColumnName("RestoranID");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.RestoranFavorits)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRestoranFa643757");

            entity.HasOne(d => d.Restoran).WithMany(p => p.RestoranFavorits)
                .HasForeignKey(d => d.RestoranId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKRestoranFa114950");
        });

        modelBuilder.Entity<StavkeNarudzbe>(entity =>
        {
            entity.HasKey(e => e.StavkeNarudzbeId).HasName("PK__StavkeNa__FA672E98C956CF71");

            entity.ToTable("StavkeNarudzbe");

            entity.Property(e => e.StavkeNarudzbeId).HasColumnName("StavkeNarudzbeID");
            entity.Property(e => e.Cijena).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");
            entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");
            entity.Property(e => e.RestoranId).HasColumnName("RestoranID");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");

            entity.HasOne(d => d.Narudzba).WithMany(p => p.StavkeNarudzbes)
                .HasForeignKey(d => d.NarudzbaId)
                .HasConstraintName("FKStavkeNaru240217");

            entity.HasOne(d => d.Proizvod).WithMany(p => p.StavkeNarudzbes)
                .HasForeignKey(d => d.ProizvodId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKStavkeNaru313239");

            entity.HasOne(d => d.Restoran).WithMany(p => p.StavkeNarudzbes)
                .HasForeignKey(d => d.RestoranId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKStavkeNaru909859");
        });

        modelBuilder.Entity<Uloge>(entity =>
        {
            entity.HasKey(e => e.UlogaId).HasName("PK__Uloge__DCAB23EB1F3E7E4E");

            entity.ToTable("Uloge");

            entity.Property(e => e.UlogaId).HasColumnName("UlogaID");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Opis)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");
        });

        modelBuilder.Entity<VrstaProizvodum>(entity =>
        {
            entity.HasKey(e => e.VrstaId).HasName("PK__VrstaPro__42CB8F0F6A7204B9");

            entity.Property(e => e.VrstaId).HasColumnName("VrstaID");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(true);
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");
        });

        modelBuilder.Entity<VrstaRestorana>(entity =>
        {
            entity.HasKey(e => e.VrstaId).HasName("PK__VrstaRes__42CB8F0FBB2B54F9");

            entity.ToTable("VrstaRestorana");

            entity.Property(e => e.VrstaId).HasColumnName("VrstaID");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(true);
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");
        });

        try
        {
            Console.WriteLine("Seed podataka");
            modelBuilder.Seed();
        }
        catch (Exception ex)
        {
            Console.WriteLine("Greška");
        }
        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
public static class ModelBuilderExtensions
{
    public static void Seed(this ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Database.VrstaProizvodum>().HasData(
            new Database.VrstaProizvodum { VrstaId = 1, Naziv = "Pizza", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 2, Naziv = "Burger", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 3, Naziv = "Sendvić", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 4, Naziv = "Tjestenina", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 5, Naziv = "Salata", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 6, Naziv = "Desert", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 7, Naziv = "Pića", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 8, Naziv = "Piletina i meso", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 9, Naziv = "Sushi", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 10, Naziv = "Tacos", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 11, Naziv = "Burritos", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 12, Naziv = "Kineska kuhinja", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 13, Naziv = "Indijska kuhinja", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 14, Naziv = "Morski plodovi", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 15, Naziv = "Zdrava hrana", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 16, Naziv = "Vafli", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 17, Naziv = "Palaćinke", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 18, Naziv = "Pita", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 19, Naziv = "Peciva", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaProizvodum { VrstaId = 20, Naziv = "Kafa", VrijemeBrisanja = null, IsDeleted = false }
        );

        modelBuilder.Entity<Database.VrstaRestorana>().HasData(
            new Database.VrstaRestorana { VrstaId = 1, Naziv = "Pizzeria", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaRestorana { VrstaId = 2, Naziv = "Italijanski restoran", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaRestorana { VrstaId = 3, Naziv = "Fast food", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaRestorana { VrstaId = 4, Naziv = "Buregžinica", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaRestorana { VrstaId = 5, Naziv = "Grill bar", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaRestorana { VrstaId = 6, Naziv = "Slastičarna", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaRestorana { VrstaId = 7, Naziv = "Meksički restoran", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaRestorana { VrstaId = 8, Naziv = "Indijski restoran", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaRestorana { VrstaId = 9, Naziv = "Ćevapdžinica", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaRestorana { VrstaId = 10, Naziv = "Palaćinkarnica", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaRestorana { VrstaId = 11, Naziv = "Sushi bar", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaRestorana { VrstaId = 12, Naziv = "Taco bar", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaRestorana { VrstaId = 13, Naziv = "Bistro", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaRestorana { VrstaId = 14, Naziv = "Tavern", VrijemeBrisanja = null, IsDeleted = false },
            new Database.VrstaRestorana { VrstaId = 15, Naziv = "Kafić sa slasticama", VrijemeBrisanja = null, IsDeleted = false }
        );

        modelBuilder.Entity<Database.Uloge>().HasData(
            new Database.Uloge { UlogaId = 1, Naziv = "Kupac", Opis="", VrijemeBrisanja = null, IsDeleted = false },
            new Database.Uloge { UlogaId = 2, Naziv = "Vlasnik", Opis="", VrijemeBrisanja = null, IsDeleted = false },
            new Database.Uloge { UlogaId = 3, Naziv = "Admin", Opis="", VrijemeBrisanja = null, IsDeleted = false },
            new Database.Uloge { UlogaId = 4, Naziv = "Dostavljac", Opis = "", VrijemeBrisanja = null, IsDeleted = false },
            new Database.Uloge { UlogaId = 5, Naziv = "RadnikRestorana", Opis = "", VrijemeBrisanja = null, IsDeleted = false }
        );

        modelBuilder.Entity<Database.Korisnici>().HasData(
            new Database.Korisnici
            {
                KorisnikId = 1,
                Ime = "Kupac",
                Prezime = "Tester",
                Email = "kupac@gmail.com",
                Telefon = "+060303101",
                KorisnickoIme = "kupac",
                LozinkaHash = "lGMKYrDQyKeTXKA5HcfML/pFbRM=",
                LozinkaSalt = "3DlxCoNsjtCd3bM8hGtimg==",
                Slika = null,
                DatumRodjenja = DateTime.Parse("2004-07-20 14:48:41.913"),
                IsDeleted = false,
                VrijemeBrisanja = null,
                RestoranId = null,
            },
             new Database.Korisnici
             {
                 KorisnikId = 2,
                 Ime = "Kupacdva",
                 Prezime = "Tester",
                 Email = "kupac2@gmail.com",
                 Telefon = "+060303101",
                 KorisnickoIme = "kupac2",
                 LozinkaHash = "lGMKYrDQyKeTXKA5HcfML/pFbRM=",
                 LozinkaSalt = "3DlxCoNsjtCd3bM8hGtimg==",
                 Slika = null,
                 DatumRodjenja = DateTime.Parse("2004-07-20 14:48:41.913"),
                 IsDeleted = false,
                 VrijemeBrisanja = null,
                 RestoranId = null,
             },
             new Database.Korisnici
             {
                 KorisnikId = 3,
                 Ime = "Vlasnik",
                 Prezime = "Tester",
                 Email = "vlasnik@gmail.com",
                 Telefon = "+060303101",
                 KorisnickoIme = "vlasnik",
                 LozinkaHash = "lGMKYrDQyKeTXKA5HcfML/pFbRM=",
                 LozinkaSalt = "3DlxCoNsjtCd3bM8hGtimg==",
                 Slika = null,
                 DatumRodjenja = DateTime.Parse("2004-07-20 14:48:41.913"),
                 IsDeleted = false,
                 VrijemeBrisanja = null,
                 RestoranId = null,
             },
             new Database.Korisnici
             {
                 KorisnikId = 4,
                 Ime = "Admin",
                 Prezime = "Tester",
                 Email = "admin@gmail.com",
                 Telefon = "+060303101",
                 KorisnickoIme = "admin",
                 LozinkaHash = "lGMKYrDQyKeTXKA5HcfML/pFbRM=",
                 LozinkaSalt = "3DlxCoNsjtCd3bM8hGtimg==",
                 Slika = null,
                 DatumRodjenja = DateTime.Parse("2004-07-20 14:48:41.913"),
                 IsDeleted = false,
                 VrijemeBrisanja = null,
                 RestoranId = null
             },
             new Database.Korisnici
             {
                 KorisnikId = 5,
                 Ime = "Dostavljac",
                 Prezime = "Tester",
                 Email = "dostavljac@gmail.com",
                 Telefon = "+060303101",
                 KorisnickoIme = "dostavljac",
                 LozinkaHash = "lGMKYrDQyKeTXKA5HcfML/pFbRM=",
                 LozinkaSalt = "3DlxCoNsjtCd3bM8hGtimg==",
                 Slika = null,
                 DatumRodjenja = DateTime.Parse("2004-07-20 14:48:41.913"),
                 IsDeleted = false,
                 VrijemeBrisanja = null,
                 RestoranId = 1,
             },
             new Database.Korisnici
             {
                 KorisnikId = 6,
                 Ime = "Dostavljac",
                 Prezime = "Tester",
                 Email = "dostavljac2@gmail.com",
                 Telefon = "+060303101",
                 KorisnickoIme = "dostavljac2",
                 LozinkaHash = "lGMKYrDQyKeTXKA5HcfML/pFbRM=",
                 LozinkaSalt = "3DlxCoNsjtCd3bM8hGtimg==",
                 Slika = null,
                 DatumRodjenja = DateTime.Parse("2004-07-20 14:48:41.913"),
                 IsDeleted = false,
                 VrijemeBrisanja = null,
                 RestoranId = 2,
             },
             new Database.Korisnici
             {
                 KorisnikId = 7,
                 Ime = "Dostavljac",
                 Prezime = "Tester",
                 Email = "dostavljac2@gmail.com",
                 Telefon = "+060303101",
                 KorisnickoIme = "dostavljac3",
                 LozinkaHash = "lGMKYrDQyKeTXKA5HcfML/pFbRM=",
                 LozinkaSalt = "3DlxCoNsjtCd3bM8hGtimg==",
                 Slika = null,
                 DatumRodjenja = DateTime.Parse("2004-07-20 14:48:41.913"),
                 IsDeleted = false,
                 VrijemeBrisanja = null,
                 RestoranId = 3,
             },
             new Database.Korisnici
             {
                 KorisnikId = 8,
                 Ime = "Dostavljac",
                 Prezime = "Tester",
                 Email = "dostavljac2@gmail.com",
                 Telefon = "+060303101",
                 KorisnickoIme = "dostavljac4",
                 LozinkaHash = "lGMKYrDQyKeTXKA5HcfML/pFbRM=",
                 LozinkaSalt = "3DlxCoNsjtCd3bM8hGtimg==",
                 Slika = null,
                 DatumRodjenja = DateTime.Parse("2004-07-20 14:48:41.913"),
                 IsDeleted = false,
                 VrijemeBrisanja = null,
                 RestoranId = 4,
             },
             new Database.Korisnici
             {
                 KorisnikId = 9,
                 Ime = "Radnikrestorana",
                 Prezime = "Tester",
                 Email = "radnikrestorana@gmail.com",
                 Telefon = "+060303101",
                 KorisnickoIme = "radnikrestorana",
                 LozinkaHash = "lGMKYrDQyKeTXKA5HcfML/pFbRM=",
                 LozinkaSalt = "3DlxCoNsjtCd3bM8hGtimg==",
                 Slika = null,
                 DatumRodjenja = DateTime.Parse("2004-07-20 14:48:41.913"),
                 IsDeleted = false,
                 VrijemeBrisanja = null,
                 RestoranId = 1,
             },
             new Database.Korisnici
             {
                 KorisnikId = 10,
                 Ime = "Radnikrestorana",
                 Prezime = "Tester",
                 Email = "radnikrestorana@gmail.com",
                 Telefon = "+060303101",
                 KorisnickoIme = "radnikrestorana2",
                 LozinkaHash = "lGMKYrDQyKeTXKA5HcfML/pFbRM=",
                 LozinkaSalt = "3DlxCoNsjtCd3bM8hGtimg==",
                 Slika = null,
                 DatumRodjenja = DateTime.Parse("2004-07-20 14:48:41.913"),
                 IsDeleted = false,
                 VrijemeBrisanja = null,
                 RestoranId = 2,
             },
             new Database.Korisnici
             {
                 KorisnikId = 11,
                 Ime = "Radnikrestorana",
                 Prezime = "Tester",
                 Email = "radnikrestorana@gmail.com",
                 Telefon = "+060303101",
                 KorisnickoIme = "radnikrestorana3",
                 LozinkaHash = "lGMKYrDQyKeTXKA5HcfML/pFbRM=",
                 LozinkaSalt = "3DlxCoNsjtCd3bM8hGtimg==",
                 Slika = null,
                 DatumRodjenja = DateTime.Parse("2004-07-20 14:48:41.913"),
                 IsDeleted = false,
                 VrijemeBrisanja = null,
                 RestoranId = 3,
             },
              new Database.Korisnici
              {
                  KorisnikId = 12,
                  Ime = "Radnikrestorana",
                  Prezime = "Tester",
                  Email = "radnikrestorana@gmail.com",
                  Telefon = "+060303101",
                  KorisnickoIme = "radnikrestorana4",
                  LozinkaHash = "lGMKYrDQyKeTXKA5HcfML/pFbRM=",
                  LozinkaSalt = "3DlxCoNsjtCd3bM8hGtimg==",
                  Slika = null,
                  DatumRodjenja = DateTime.Parse("2004-07-20 14:48:41.913"),
                  IsDeleted = false,
                  VrijemeBrisanja = null,
                  RestoranId = 4,
              }
        );

        modelBuilder.Entity<Database.Lokacija>().HasData(
            new Database.Lokacija
            {
                LokacijaId=1,
                KorisnikId=1,
                Adresa=null,
                GeografskaDuzina= (decimal)17.8150160106649,
                GeografskaSirina= (decimal)43.33737715044256,
                IsDeleted=false,
                VrijemeBrisanja=null,
            },
             new Database.Lokacija
             {
                 LokacijaId = 2,
                 KorisnikId = 2,
                 Adresa = null,
                 GeografskaDuzina = (decimal)17.8150160106649,
                 GeografskaSirina = (decimal)43.33737715044256,
                 IsDeleted = false,
                 VrijemeBrisanja = null,
             }
        );

        modelBuilder.Entity<Database.KorisniciUloge>().HasData(
            new Database.KorisniciUloge
            {
                KorisnikUlogaId = 1,
                KorisnikId = 1,
                UlogaId = 1,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Database.KorisniciUloge
            {
                KorisnikUlogaId = 2,
                KorisnikId = 2,
                UlogaId = 1,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Database.KorisniciUloge
            {
                KorisnikUlogaId = 3,
                KorisnikId = 3,
                UlogaId = 2,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Database.KorisniciUloge
            {
                KorisnikUlogaId = 4,
                KorisnikId = 4,
                UlogaId = 3,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Database.KorisniciUloge
            {
                KorisnikUlogaId = 5,
                KorisnikId = 5,
                UlogaId = 4,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Database.KorisniciUloge
            {
                KorisnikUlogaId = 6,
                KorisnikId = 6,
                UlogaId = 4,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Database.KorisniciUloge
            {
                KorisnikUlogaId = 7,
                KorisnikId = 7,
                UlogaId = 4,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Database.KorisniciUloge
            {
                KorisnikUlogaId = 8,
                KorisnikId = 8,
                UlogaId = 4,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Database.KorisniciUloge
            {
                KorisnikUlogaId = 9,
                KorisnikId = 9,
                UlogaId = 5,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Database.KorisniciUloge
            {
                KorisnikUlogaId = 10,
                KorisnikId = 10,
                UlogaId = 5,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Database.KorisniciUloge
            {
                KorisnikUlogaId = 11,
                KorisnikId = 11,
                UlogaId = 5,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Database.KorisniciUloge
            {
                KorisnikUlogaId = 12,
                KorisnikId = 12,
                UlogaId = 5,
                IsDeleted = false,
                VrijemeBrisanja = null
            }
        );

        modelBuilder.Entity<Database.Restoran>().HasData(
            new Database.Restoran()
            {
                RestoranId = 1,
                Naziv = "Pizzeria Nerry",
                RadnoVrijemeOd = "08:00",
                RadnoVrijemeDo = "22:00",
                Slika = null,
                Lokacija = "Branilaca Bosne bb, Blagaj",
                IsDeleted = false,
                VrijemeBrisanja = null,
                StateMachine = null,
                VrstaRestoranaId = 1,
                VlasnikId = 3
            },
            new Database.Restoran()
            {
                RestoranId = 2,
                Naziv = "Restoran Čaršija",
                RadnoVrijemeOd = "08:00",
                RadnoVrijemeDo = "22:00",
                Slika = null,
                Lokacija = "Branilaca Bosne bb, Blagaj",
                IsDeleted = false,
                VrijemeBrisanja = null,
                StateMachine = null,
                VrstaRestoranaId = 3,
                VlasnikId = 3
            },
            new Database.Restoran()
            {
                RestoranId = 3,
                Naziv = "Slastičarna Ada",
                RadnoVrijemeOd = "08:00",
                RadnoVrijemeDo = "22:00",
                Slika = null,
                Lokacija = "Branilaca Bosne bb, Blagaj",
                IsDeleted = false,
                VrijemeBrisanja = null,
                StateMachine = null,
                VrstaRestoranaId = 15,
                VlasnikId = 3
            },
            new Database.Restoran()
            {
                RestoranId = 4,
                Naziv = "Restoran Royal",
                RadnoVrijemeOd = "08:00",
                RadnoVrijemeDo = "22:00",
                Slika = null,
                Lokacija = "Branilaca Bosne bb, Blagaj",
                IsDeleted = false,
                VrijemeBrisanja = null,
                StateMachine = null,
                VrstaRestoranaId = 13,
                VlasnikId = 3
            }
        );

        modelBuilder.Entity<Database.Proizvod>().HasData(
            new Database.Proizvod()
            {
                ProizvodId = 1,
                Naziv = "Pizza Mexicana",
                Cijena = 12,
                Opis = "Pizza Mexicana u restoranu Pizzeria Nerry predstavlja savršenu harmoniju meksičkih i italijanskih okusa.\n" +
                "Pripremljena na savršeno tankom, hrskavom tijestu, ova pizza je prekrivena bogatim umakom od paradajza\n," +
                " začinjenim mljevenim mesom, slatkim kukuruzom, crvenim grahom i hrskavim papričicama.\n" +
                "Jalapeño paprike dodaju dozu pikantnosti koja budi sva čula, dok se otopljeni\n" +
                " sloj mozzarelle brine za savršenu kremastost svakog zalogaja.",
                Slika = null,
                VrijemeBrisanja = null,
                StateMachine = null,
                VrstaProizvodaId = 1,
                RestoranId = 1,
            },
            new Database.Proizvod()
            {
                ProizvodId = 2,
                Naziv = "Chicken Pizza",
                Cijena = 12,
                Opis = "Chicken pizza je savršena kombinacija sočnih komadića piletine, topljenog sira i ukusnog tijesta.\n" +
                "Obogaćena mješavinom začina i svježim povrćem, poput paprike i luka,\n" +
                " ova pizza nudi bogat i ukusan obrok idealan za ljubitelje piletine i klasičnih pizza okusa.",
                Slika = null,
                VrijemeBrisanja = null,
                StateMachine = null,
                VrstaProizvodaId = 1,
                RestoranId = 1,
            },
            new Database.Proizvod()
            {
                ProizvodId = 3,
                Naziv = "Pizza Margherita",
                Cijena = 12,
                Opis = "Pizza Margherita je klasična italijanska pizza koja osvaja svojom jednostavnošću i savršenim balansom okusa.\n" +
                "Priprema se od svježeg tijesta, premazana umakom od zrelih paradajza, posuta topljenim mozzarella sirom i aromatičnim listovima svježeg bosiljka.\n" +
                "Ovo jelo simbolizira autentičnost i tradiciju italijanske kuhinje.",
                Slika = null,
                VrijemeBrisanja = null,
                StateMachine = null,
                VrstaProizvodaId = 1,
                RestoranId = 1,
            },
            new Database.Proizvod()
            {
                ProizvodId = 4,
                Naziv = "Pizza capricciosa",
                Cijena = 11,
                Opis = "Pizza Capricciosa je bogata i raznovrsna pizza koja spaja najukusnije sastojke.\n" +
                "Klasično tijesto premazano je umakom od paradajza\n" +
                " i posuto topljenim mozzarella sirom, uz dodatak šunke, svježih šampinjona, maslina i artičoka.\n" +
                "Svaki zalogaj pruža savršenu harmoniju okusa, idealnu za ljubitelje bogatijih i tradicionalnih pizza.",
                Slika = null,
                VrijemeBrisanja = null,
                StateMachine = null,
                VrstaProizvodaId = 1,
                RestoranId = 1,
            },
            new Database.Proizvod()
            {
                ProizvodId = 5,
                Naziv = "Pizza Quattro Formaggi",
                Cijena = 10,
                Opis = "Pizza Quattro Formaggi je pravi raj za ljubitelje sira. Priprema se na klasičnom tijestu\n" +
                ", premazanom tankim slojem umaka od paradajza (ili bez njega, u bijeloj verziji) te obilno posutom kombinacijom\n" +
                " četiri vrste sira: mozzarella, gorgonzola, parmezan i ricotta.\n" +
                "Svaka vrsta sira doprinosi bogatstvu i kremastoj teksturi, stvarajući intenzivan i nezaboravan okus.",
                Slika = null,
                VrijemeBrisanja = null,
                StateMachine = null,
                VrstaProizvodaId = 1,
                RestoranId = 1,
            },
             new Database.Proizvod()
             {
                 ProizvodId = 6,
                 Naziv = "Pizza Diavola ",
                 Cijena = 10,
                 Opis = "Pizza Diavola je prava poslastica za ljubitelje začinjenih jela. \n" +
                 "Na hrskavom tijestu nalazi se bogat sloj umaka od paradajza, topila mozzarella i obilje ljutih sastojaka poput pikantne salame,\n" +
                 " crvenih paprika i maslina. Ova pizza pruža savršen balans između ljutine i bogatog okusa,\n" +
                 " idealna za one koji vole uživati u intenzivnim i začinjenim jelima.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 1,
                 RestoranId = 1,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 7,
                 Naziv = "Burger Classic",
                 Cijena = 8,
                 Opis = "Burger Classic je jednostavan, ali ukusan izbor za sve ljubitelje klasičnih burgera.\n" +
                 "Sastoji se od sočne pljeskavice od mljevene govedine, koja je savršeno pečena i poslužen je u mekanom pecivu.\n" +
                 "Dodaju se svježi sastojci poput zelene salate, rajčice, kiselih krastavaca i luka, te se sve začini s majonezom, senfom ili kečapom po želji.\n" +
                 "Ovaj burger nudi savršen spoj okusa, s bogatim mesom i svježim povrćem, idealan za ljubitelje jednostavnih i kvalitetnih jela.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 2,
                 RestoranId = 2,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 8,
                 Naziv = "Cheeseburger",
                 Cijena = 8,
                 Opis = "Cheeseburger je savršen izbor za ljubitelje sira. Sastoji se od sočne goveđe pljeskavice na kojoj se topi\n" +
                 " sloj rastopljenog cheddar sira. Uz to, u mekanom pecivu dolaze svježi krastavci, rajčica, zelena salata i luk,\n" +
                 " s dodatkom umaka po izboru (majoneza, kečap ili senf). Ovaj burger pruža bogatstvo okusa s kombinacijom sira, mesa i povrća,\n" +
                 " pružajući savršeno zadovoljstvo za svakog ljubitelja klasične kombinacije.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 2,
                 RestoranId = 2,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 9,
                 Naziv = "BBQ Burger",
                 Cijena = 10,
                 Opis = "BBQ Burger je pravi izbor za ljubitelje dimljenih i slatko-ljutih okusa.\n" +
                 "Sastoji se od sočne goveđe pljeskavice, na kojoj je sloj topljenog cheddar sira, a cijeli burger je premazan bogatim\n" +
                 "BBQ umakom koji mu daje specifičan dimljeni okus. Uz to, dodaju se kriške svježeg luka, kiselih krastavaca i hrskava slanina, sve u mekanom pecivu.\n" +
                 "Ovaj burger nudi kombinaciju slatko-dimljenih okusa s hrskavim teksturama, idealan za sve koji uživaju u bogatim, intenzivnim jelima.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 2,
                 RestoranId = 2,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 10,
                 Naziv = "Mushroom Swiss Burger",
                 Cijena = 10,
                 Opis = "Mushroom Swiss Burger je delikatan burger za ljubitelje gljiva i sira.\n" +
                 "Sočna goveđa pljeskavica prekrivena je slojem rastopljenog švicarskog sira i pečenim gljivama,\n" +
                 " koje dodaju bogatstvo okusa i aromu.Uz to, dolaze svježi krastavci, rajčica i povrće po izboru, sve smješteno u mekanom pecivu.\n" +
                 "Ovaj burger je savršen spoj umami okusa i svježih sastojaka, idealan za one koji traže sofisticiraniju verziju klasičnog burgera.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 2,
                 RestoranId = 2,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 11,
                 Naziv = "Club Sandwich",
                 Cijena = 6,
                 Opis = "Club sandwich je klasični sendvič koji nudi savršen spoj okusa i tekstura.\n" +
                 "Sastoji se od tri sloja svježeg bijelog kruha, svaki prepun bogatog nadeva od pečene piletine, hrskave slanine, svježih rajčica,\n" +
                 " zelene salate i majoneze. Ovaj sendvič nudi bogatstvo okusa, od sočne piletine i hrskave slanine do osvježavajuće salate i rajčica,\n" +
                 " sve to upotpunjeno kremastim majonezom. Savršen je izbor za sve koji žele uživati u klasičnom, ali ukusnom sendviču.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 3,
                 RestoranId = 2,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 12,
                 Naziv = "Tuna Salad Sandwich",
                 Cijena = 9,
                 Opis = "Tuna salad sandwich je lagan i ukusan sendvič koji je savršen za ljubitelje tune. \n" +
                 "Ovaj sendvič sadrži kremastu salatu od tune,\n" +
                 " pomiješanu s majonezom, senfom i začinima, uz svježe povrće poput luka, krastavaca i rajčica. Sve je smješteno između dva komada\n" +
                 " mekanog integralnog ili bijelog kruha. Ovaj sendvič nudi jednostavan, ali bogat okus, s savršenom ravnotežom\n" +
                 " između sočne tune i svježeg povrća.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 3,
                 RestoranId = 2,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 13,
                 Naziv = "Čokoladni Brownie",
                 Cijena = 4,
                 Opis = "Brownie je sočan, gust i bogat čokoladni kolač, obično s komadićima tamne čokolade\n" +
                 " ili čokoladnim komadićima u tijestu. Njegova tekstura je između biskvita i fudgy smjese, s hrskavom koricom\n" +
                 " i sočnim srednjim dijelom. Savršen je za ljubitelje tamne čokolade.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 6,
                 RestoranId = 3,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 14,
                 Naziv = "Vanilija Cupcake",
                 Cijena = 5,
                 Opis = "Vanilija cupcake je lagani, mekani kolač s predivnim vanilija okusom. Obično je prekriven šarenom\n" +
                 " glazurom od maslaca, uz dodatak dekoracija poput šarenih mrvica ili jestivih cvjetova. Ovaj kolač je savršen\n" +
                 " za sve prigode, od rođendanskih zabava do opuštenih popodneva s prijateljima.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 6,
                 RestoranId = 3,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 15,
                 Naziv = "Kolač od Limuna i Poppy Seeds (Mak)",
                 Cijena = 5,
                 Opis = "Ovaj kolač nudi savršenu ravnotežu svježeg okusa limuna i blagih, hrskavih sjemenki maka.\n" +
                 "Lagano je vlažan, a nježna tekstura čini ga savršenim za uživanje uz čaj ili kavu.\n" +
                 "Svježina limuna i mala količina maka daju ovom kolaču jedinstvenu aromu i boju.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 6,
                 RestoranId = 3,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 16,
                 Naziv = "Palačinke sa Nutellom",
                 Cijena = 5,
                 Opis = "Klasične tanke palačinke prekrivene bogatom Nutellom, čokoladnom kremom koja je omiljena među ljubiteljima slatkog.\n" +
                 "Nutella se jednostavno nanosi na još tople palačinke, a često se dodaju i kesten pire, šlag ili komadići voća poput banana za dodatni okus.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 6,
                 RestoranId = 3,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 17,
                 Naziv = "Palačinke sa Jagodama i Šlagom",
                 Cijena = 6,
                 Opis = "Palačinke punjene svježim jagodama i prelivene šlagom. Ovaj jednostavan, ali ukusan desert donosi \n" +
                 "savršenu ravnotežu između kiselkaste svježine jagoda i slatkog šlaga, stvarajući laganu\n" +
                 " i osvježavajuću poslasticu, idealnu za ljetne dane.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 6,
                 RestoranId = 3,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 18,
                 Naziv = "Palačinke sa Nutellom i Banama",
                 Cijena = 6,
                 Opis = "Jednostavne palačinke sa kremom od Nutelle, dodatno obogaćene svježim kolutićima banana.\n" +
                 "Ova kombinacija čokolade i voća stvara savršen balans slatkog i voćnog okusa, a često se poslužuje\n" +
                 " i sa malo grčkog jogurta ili šlaga za kremastu teksturu.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 6,
                 RestoranId = 3,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 19,
                 Naziv = "Quiche",
                 Cijena = 6,
                 Opis = "Kremasti kolač od prhkog tijesta, obično punjen sa kombinacijom jaja, vrhnja, sira i povrća ili mesa.\n" +
                 " Popularni su quiche sa špinatom, slaninom ili gljivama.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 6,
                 RestoranId = 4,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 20,
                 Naziv = "Croque Monsieur",
                 Cijena = 6,
                 Opis = "Francuski sendvič od toasta sa šunkom i sirom, preliven bešamel \n" +
                 "sosom i zapečen u pećnici do zlatne boje.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 3,
                 RestoranId = 4,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 21,
                 Naziv = "Ratatouille",
                 Cijena = 12,
                 Opis = "Klasično francusko jelo od povrća (patlidžan, tikvice, paprika, paradajz i luk), kuhano sa maslinovim uljemn" +
                 " i začinskim biljem. Lagano, zdravo i puno okusa.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 15,
                 RestoranId = 4,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 22,
                 Naziv = "Steak Frites",
                 Cijena = 14,
                 Opis = "Jednostavan, ali ukusan obrok: sočni odrezak (obično od goveđeg mesa) poslužuje se sa prženim pomfritima, \b" +
                 "često uz neki umak poput umaka od crnog vina ili beurre maître d'hôtel.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 8,
                 RestoranId = 4,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 23,
                 Naziv = "Salata Niçoise",
                 Cijena = 10,
                 Opis = "Francuska salata koja uključuje paradajz, krastavce, crne masline, \n" +
                 "zelenu salatu i kuhane krumpire, obično začinjenu sa maslinovim uljem i balzamičnim octom.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 15,
                 RestoranId = 4,
             },
             new Database.Proizvod()
             {
                 ProizvodId = 24,
                 Naziv = "Quiche Lorraine",
                 Cijena = 12,
                 Opis = "Quiche Lorraine je klasično francusko jelo koje potiče iz Lorraine regije, a danas je \n" +
                 "popularno širom sveta. Osim pancete, u receptu se često mogu dodati i druge sastojke poput sira,\n" +
                 " luka ili povrća, zavisno od varijacije.",
                 Slika = null,
                 VrijemeBrisanja = null,
                 StateMachine = null,
                 VrstaProizvodaId = 18,
                 RestoranId = 4,
             }
        );

        modelBuilder.Entity<Database.OcjenaRestoran>().HasData(
            new Database.OcjenaRestoran()
            {
                OcjenaRestoranId = 1,
                Ocjena = 4,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                RestoranId = 1,
                KorisnikId = 1
            },
            new Database.OcjenaRestoran()
            {
                OcjenaRestoranId = 2,
                Ocjena = 5,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                RestoranId = 2,
                KorisnikId = 1
            },
            new Database.OcjenaRestoran()
            {
                OcjenaRestoranId = 3,
                Ocjena = 3,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                RestoranId = 3,
                KorisnikId = 1
            },
            new Database.OcjenaRestoran()
            {
                OcjenaRestoranId = 4,
                Ocjena = 3,
                IsDeleted = false,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                RestoranId = 4,
                KorisnikId = 1
            },
            new Database.OcjenaRestoran()
            {
                OcjenaRestoranId = 5,
                Ocjena = 5,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                RestoranId = 1,
                KorisnikId = 2
            },
            new Database.OcjenaRestoran()
            {
                OcjenaRestoranId = 6,
                Ocjena = 4,
                IsDeleted = false,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                RestoranId = 2,
                KorisnikId = 2
            },
            new Database.OcjenaRestoran()
            {
                OcjenaRestoranId = 7,
                Ocjena = 3,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                RestoranId = 3,
                KorisnikId = 2
            },
            new Database.OcjenaRestoran()
            {
                OcjenaRestoranId = 8,
                Ocjena = 2,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                RestoranId = 4,
                KorisnikId = 2
            }
        );

        modelBuilder.Entity<Database.OcjenaProizvod>().HasData(
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 1,
                Ocjena = 4,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 1,
                ProizvodId = 1,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 2,
                Ocjena = 3,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 1,
                ProizvodId = 2,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 3,
                Ocjena = 4,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 1,
                ProizvodId = 3,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 4,
                Ocjena = 3,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 1,
                ProizvodId = 7,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 5,
                Ocjena = 5,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 1,
                ProizvodId = 8,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 6,
                Ocjena = 3,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 1,
                ProizvodId = 9,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 7,
                Ocjena = 3,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 1,
                ProizvodId = 13,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 8,
                Ocjena = 3,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 1,
                ProizvodId = 14,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 9,
                Ocjena = 4,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 1,
                ProizvodId = 15,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 10,
                Ocjena = 4,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 1,
                ProizvodId = 19,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 11,
                Ocjena = 2,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 1,
                ProizvodId = 20,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 12,
                Ocjena = 3,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 1,
                ProizvodId = 21,
            },
             new Database.OcjenaProizvod()
             {
                 OcjenaProizvodId = 13,
                 Ocjena = 4,
                 DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                 IsDeleted = false,
                 VrijemeBrisanja = null,
                 KorisnikId = 2,
                 ProizvodId = 4,
             },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 14,
                Ocjena = 3,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 2,
                ProizvodId = 5,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 15,
                Ocjena = 4,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 2,
                ProizvodId = 6,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 16,
                Ocjena = 3,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 2,
                ProizvodId = 10,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 17,
                Ocjena = 5,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 2,
                ProizvodId = 11,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 18,
                Ocjena = 3,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 2,
                ProizvodId = 12,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 19,
                Ocjena = 3,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 2,
                ProizvodId = 16,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 20,
                Ocjena = 3,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 2,
                ProizvodId = 17,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 21,
                Ocjena = 4,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 2,
                ProizvodId = 18,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 22,
                Ocjena = 4,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 2,
                ProizvodId = 22,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 23,
                Ocjena = 2,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 2,
                ProizvodId = 23,
            },
            new Database.OcjenaProizvod()
            {
                OcjenaProizvodId = 24,
                Ocjena = 3,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 2,
                ProizvodId = 24,
            }
        );

        modelBuilder.Entity<Database.Narudzba>().HasData(
            new Database.Narudzba()
            {
                NarudzbaId = 1,
                BrojNarudzbe = 4324,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                VrijemeBrisanja = null,
                IsDeleted = false,
                StateMachine = "kreirana",
                UkupnaCijena = 36,
                KorisnikId = 1,
                DostavljacId = null,
            },
            new Database.Narudzba()
            {
                NarudzbaId = 2,
                BrojNarudzbe = 3042,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                VrijemeBrisanja = null,
                IsDeleted = false,
                StateMachine = "kreirana",
                UkupnaCijena = 25,
                KorisnikId = 1,
                DostavljacId = null,
            },
            new Database.Narudzba()
            {
                NarudzbaId = 3,
                BrojNarudzbe = 3042,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                VrijemeBrisanja = null,
                IsDeleted = false,
                StateMachine = "kreirana",
                UkupnaCijena = 16,
                KorisnikId = 2,
                DostavljacId = null,
            },
            new Database.Narudzba()
            {
                NarudzbaId = 4,
                BrojNarudzbe = 1092,
                DatumKreiranja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                VrijemeBrisanja = null,
                IsDeleted = false,
                StateMachine = "kreirana",
                UkupnaCijena = 30,
                KorisnikId = 2,
                DostavljacId = null,
            }
        );

        modelBuilder.Entity<Database.StavkeNarudzbe>().HasData(
            new Database.StavkeNarudzbe()
            {
                StavkeNarudzbeId = 1,
                Kolicina = 1,
                Cijena = 12,
                IsDeleted = false,
                VrijemeBrisanja = null,
                NarudzbaId = 1,
                ProizvodId = 1,
                RestoranId = 1,
            },
            new Database.StavkeNarudzbe()
            {
                StavkeNarudzbeId = 2,
                Kolicina = 1,
                Cijena = 12,
                IsDeleted = false,
                VrijemeBrisanja = null,
                NarudzbaId = 1,
                ProizvodId = 2,
                RestoranId = 1,
            },
            new Database.StavkeNarudzbe()
            {
                StavkeNarudzbeId = 3,
                Kolicina = 1,
                Cijena = 12,
                IsDeleted = false,
                VrijemeBrisanja = null,
                NarudzbaId = 1,
                ProizvodId = 3,
                RestoranId = 1,
            },
            new Database.StavkeNarudzbe()
            {
                StavkeNarudzbeId = 4,
                Kolicina = 1,
                Cijena = 8,
                IsDeleted = false,
                VrijemeBrisanja = null,
                NarudzbaId = 2,
                ProizvodId = 7,
                RestoranId = 2,
            },
            new Database.StavkeNarudzbe()
            {
                StavkeNarudzbeId = 5,
                Kolicina = 1,
                Cijena = 8,
                IsDeleted = false,
                VrijemeBrisanja = null,
                NarudzbaId = 2,
                ProizvodId = 8,
                RestoranId = 2,
            },
            new Database.StavkeNarudzbe()
            {
                StavkeNarudzbeId = 6,
                Kolicina = 1,
                Cijena = 9,
                IsDeleted = false,
                VrijemeBrisanja = null,
                NarudzbaId = 2,
                ProizvodId = 12,
                RestoranId = 2,
            },
            new Database.StavkeNarudzbe()
            {
                StavkeNarudzbeId = 7,
                Kolicina = 1,
                Cijena = 5,
                IsDeleted = false,
                VrijemeBrisanja = null,
                NarudzbaId = 3,
                ProizvodId = 14,
                RestoranId = 3,
            },
            new Database.StavkeNarudzbe()
            {
                StavkeNarudzbeId = 8,
                Kolicina = 1,
                Cijena = 5,
                IsDeleted = false,
                VrijemeBrisanja = null,
                NarudzbaId = 3,
                ProizvodId = 15,
                RestoranId = 3,
            },
            new Database.StavkeNarudzbe()
            {
                StavkeNarudzbeId = 9,
                Kolicina = 1,
                Cijena = 6,
                IsDeleted = false,
                VrijemeBrisanja = null,
                NarudzbaId = 3,
                ProizvodId = 17,
                RestoranId = 3,
            },
            new Database.StavkeNarudzbe()
            {
                StavkeNarudzbeId = 10,
                Kolicina = 1,
                Cijena = 6,
                IsDeleted = false,
                VrijemeBrisanja = null,
                NarudzbaId = 4,
                ProizvodId = 20,
                RestoranId = 4,
            },
            new Database.StavkeNarudzbe()
            {
                StavkeNarudzbeId = 11,
                Kolicina = 1,
                Cijena = 12,
                IsDeleted = false,
                VrijemeBrisanja = null,
                NarudzbaId = 4,
                ProizvodId = 21,
                RestoranId = 4,
            },
            new Database.StavkeNarudzbe()
            {
                StavkeNarudzbeId = 13,
                Kolicina = 1,
                Cijena = 12,
                IsDeleted = false,
                VrijemeBrisanja = null,
                NarudzbaId = 4,
                ProizvodId = 24,
                RestoranId = 4,
            }
        );

        modelBuilder.Entity<Database.RestoranFavorit>().HasData(
            new Database.RestoranFavorit()
            {
                RestoranFavoritId = 1,
                DatumDodavanja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 1,
                RestoranId = 1,
            },
            new Database.RestoranFavorit()
            {
                RestoranFavoritId = 2,
                DatumDodavanja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 1,
                RestoranId = 2,
            },
            new Database.RestoranFavorit()
            {
                RestoranFavoritId = 3,
                DatumDodavanja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 2,
                RestoranId = 3,
            },
            new Database.RestoranFavorit()
            {
                RestoranFavoritId = 4,
                DatumDodavanja = new DateTime(2024, 8, 11, 15, 45, 20, 837),
                IsDeleted = false,
                VrijemeBrisanja = null,
                KorisnikId = 2,
                RestoranId = 4,
            }
        );
    }
}
