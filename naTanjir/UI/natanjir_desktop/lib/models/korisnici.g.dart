// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnici.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnici _$KorisniciFromJson(Map<String, dynamic> json) => Korisnici()
  ..korisnikId = (json['korisnikId'] as num?)?.toInt()
  ..ime = json['ime'] as String?
  ..prezime = json['prezime'] as String?
  ..email = json['email'] as String?
  ..telefon = json['telefon'] as String?
  ..korisnickoIme = json['korisnickoIme'] as String?
  ..datumRodjenja = json['datumRodjenja'] as String?
  ..slika = json['slika'] as String?
  ..isDeleted = json['isDeleted'] as bool?
  ..restoranId = (json['restoranId'] as num?)?.toInt()
  ..restoran = json['restoran'] == null
      ? null
      : Restoran.fromJson(json['restoran'] as Map<String, dynamic>)
  ..korisniciUloges = (json['korisniciUloges'] as List<dynamic>?)
      ?.map((e) => KorisnikUloga.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$KorisniciToJson(Korisnici instance) => <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'telefon': instance.telefon,
      'korisnickoIme': instance.korisnickoIme,
      'datumRodjenja': instance.datumRodjenja,
      'slika': instance.slika,
      'isDeleted': instance.isDeleted,
      'restoranId': instance.restoranId,
      'restoran': instance.restoran,
      'korisniciUloges': instance.korisniciUloges,
    };
