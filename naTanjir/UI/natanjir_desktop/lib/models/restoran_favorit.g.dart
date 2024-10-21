// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restoran_favorit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestoranFavorit _$RestoranFavoritFromJson(Map<String, dynamic> json) =>
    RestoranFavorit()
      ..restoranFavoritId = (json['restoranFavoritId'] as num?)?.toInt()
      ..datumDodavanja = json['datumDodavanja'] as String?
      ..korisnikId = (json['korisnikId'] as num?)?.toInt()
      ..restoranId = (json['restoranId'] as num?)?.toInt()
      ..korisnik = json['korisnik'] == null
          ? null
          : Korisnici.fromJson(json['korisnik'] as Map<String, dynamic>)
      ..restoran = json['restoran'] == null
          ? null
          : Restoran.fromJson(json['restoran'] as Map<String, dynamic>)
      ..isFavorit = json['isFavorit'] as bool?;

Map<String, dynamic> _$RestoranFavoritToJson(RestoranFavorit instance) =>
    <String, dynamic>{
      'restoranFavoritId': instance.restoranFavoritId,
      'datumDodavanja': instance.datumDodavanja,
      'korisnikId': instance.korisnikId,
      'restoranId': instance.restoranId,
      'korisnik': instance.korisnik,
      'restoran': instance.restoran,
      'isFavorit': instance.isFavorit,
    };
