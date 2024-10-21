// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stavke_narudzbe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StavkeNarudzbe _$StavkeNarudzbeFromJson(Map<String, dynamic> json) =>
    StavkeNarudzbe()
      ..stavkeNarudzbeId = (json['stavkeNarudzbeId'] as num?)?.toInt()
      ..kolicina = (json['kolicina'] as num?)?.toInt()
      ..cijena = (json['cijena'] as num?)?.toDouble()
      ..narudzbaId = (json['narudzbaId'] as num?)?.toInt()
      ..proizvodId = (json['proizvodId'] as num?)?.toInt()
      ..korisnikId = (json['korisnikId'] as num?)?.toInt()
      ..restoranId = (json['restoranId'] as num?)?.toInt()
      ..proizvod = json['proizvod'] == null
          ? null
          : Proizvod.fromJson(json['proizvod'] as Map<String, dynamic>)
      ..restoran = json['restoran'] == null
          ? null
          : Restoran.fromJson(json['restoran'] as Map<String, dynamic>);

Map<String, dynamic> _$StavkeNarudzbeToJson(StavkeNarudzbe instance) =>
    <String, dynamic>{
      'stavkeNarudzbeId': instance.stavkeNarudzbeId,
      'kolicina': instance.kolicina,
      'cijena': instance.cijena,
      'narudzbaId': instance.narudzbaId,
      'proizvodId': instance.proizvodId,
      'korisnikId': instance.korisnikId,
      'restoranId': instance.restoranId,
      'proizvod': instance.proizvod,
      'restoran': instance.restoran,
    };
