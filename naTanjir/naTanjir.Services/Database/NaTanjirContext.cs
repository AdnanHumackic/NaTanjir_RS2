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

    public virtual DbSet<Upit> Upits { get; set; }

    public virtual DbSet<VrstaProizvodum> VrstaProizvoda { get; set; }

    public virtual DbSet<VrstaRestorana> VrstaRestoranas { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=localhost, 1433;Initial Catalog=naTanjir;user=sa;Password=QWEasd123!;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Korisnici>(entity =>
        {
            entity.HasKey(e => e.KorisnikId).HasName("PK__Korisnic__80B06D619768E04A");

            entity.ToTable("Korisnici");

            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.DatumRodjenja).HasColumnType("date");
            entity.Property(e => e.Email)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Ime)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.KorisnickoIme)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.LokacijaId).HasColumnName("LokacijaID");
            entity.Property(e => e.LozinkaHash)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.LozinkaSalt)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Prezime)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Slika).HasMaxLength(2000);
            entity.Property(e => e.Telefon)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");

            entity.HasOne(d => d.Lokacija).WithMany(p => p.Korisnicis)
                .HasForeignKey(d => d.LokacijaId)
                .HasConstraintName("FKKorisnici502920");
        });

        modelBuilder.Entity<KorisniciUloge>(entity =>
        {
            entity.HasKey(e => e.KorisnikUlogaId).HasName("PK__Korisnic__1608720E6AA5ACAB");

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
            entity.HasKey(e => e.LokacijaId).HasName("PK__Lokacija__49DE2C2A078D5AC1");

            entity.ToTable("Lokacija");

            entity.Property(e => e.LokacijaId).HasColumnName("LokacijaID");
            entity.Property(e => e.GeografskaDuzina).HasColumnType("decimal(18, 8)");
            entity.Property(e => e.GeografskaSirina).HasColumnType("decimal(18, 8)");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");
        });

        modelBuilder.Entity<Narudzba>(entity =>
        {
            entity.HasKey(e => e.NarudzbaId).HasName("PK__Narudzba__FBEC135724919247");

            entity.ToTable("Narudzba");

            entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");
            entity.Property(e => e.DatumKreiranja).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.StateMachine)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UkupnaCijena).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Narudzbas)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKNarudzba980749");
        });

        modelBuilder.Entity<OcjenaProizvod>(entity =>
        {
            entity.HasKey(e => e.OcjenaProizvodId).HasName("PK__OcjenaPr__B0C8530FAAF60EC7");

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
            entity.HasKey(e => e.OcjenaRestoranId).HasName("PK__OcjenaRe__993C51F7171BE3F5");

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
            entity.HasKey(e => e.ProizvodId).HasName("PK__Proizvod__21A8BE18D6691FD0");

            entity.ToTable("Proizvod");

            entity.Property(e => e.ProizvodId).HasColumnName("ProizvodID");
            entity.Property(e => e.Cijena).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Opis)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.RestoranId).HasColumnName("RestoranID");
            entity.Property(e => e.Slika).HasMaxLength(2000);
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
            entity.HasKey(e => e.RestoranId).HasName("PK__Restoran__259AB1A78327C628");

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
            entity.Property(e => e.Slika).HasMaxLength(2000);
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
            entity.HasKey(e => e.RestoranFavoritId).HasName("PK__Restoran__2953C4B422E60EA7");

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
            entity.HasKey(e => e.StavkeNarudzbeId).HasName("PK__StavkeNa__FA672E98025D469D");

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
            entity.HasKey(e => e.UlogaId).HasName("PK__Uloge__DCAB23EBA808E498");

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

        modelBuilder.Entity<Upit>(entity =>
        {
            entity.HasKey(e => e.UpitId).HasName("PK__Upit__EF8C13F298D352FF");

            entity.ToTable("Upit");

            entity.Property(e => e.UpitId).HasColumnName("UpitID");
            entity.Property(e => e.DatumKreiranja).HasColumnType("date");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Naslov)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Odgovor)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.RestoranId).HasColumnName("RestoranID");
            entity.Property(e => e.Sadržaj)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Upits)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKUpit16516");

            entity.HasOne(d => d.Restoran).WithMany(p => p.Upits)
                .HasForeignKey(d => d.RestoranId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FKUpit742191");
        });

        modelBuilder.Entity<VrstaProizvodum>(entity =>
        {
            entity.HasKey(e => e.VrstaId).HasName("PK__VrstaPro__42CB8F0F361B3E75");

            entity.Property(e => e.VrstaId).HasColumnName("VrstaID");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");
        });

        modelBuilder.Entity<VrstaRestorana>(entity =>
        {
            entity.HasKey(e => e.VrstaId).HasName("PK__VrstaRes__42CB8F0F1AF248B8");

            entity.ToTable("VrstaRestorana");

            entity.Property(e => e.VrstaId).HasColumnName("VrstaID");
            entity.Property(e => e.Naziv)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("date");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
