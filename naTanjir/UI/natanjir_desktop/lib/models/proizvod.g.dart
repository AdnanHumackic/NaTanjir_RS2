// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proizvod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Proizvod _$ProizvodFromJson(Map<String, dynamic> json) => Proizvod(
      proizvodId: (json['proizvodId'] as num?)?.toInt(),
      naziv: json['naziv'] as String?,
    )
      ..slika = json['slika'] as String?
      ..cijena = (json['cijena'] as num?)?.toDouble()
      ..vrstaProizvodaId = (json['vrstaProizvodaId'] as num?)?.toInt()
      ..opis = json['opis'] as String?
      ..restoranId = (json['restoranId'] as num?)?.toInt()
      ..vrstaProizvoda = json['vrstaProizvoda'] == null
          ? null
          : VrstaProizvodum.fromJson(
              json['vrstaProizvoda'] as Map<String, dynamic>)
      ..restoran = json['restoran'] == null
          ? null
          : Restoran.fromJson(json['restoran'] as Map<String, dynamic>)
      ..isDeleted = json['isDeleted'] as bool?;

Map<String, dynamic> _$ProizvodToJson(Proizvod instance) => <String, dynamic>{
      'proizvodId': instance.proizvodId,
      'naziv': instance.naziv,
      'slika': instance.slika,
      'cijena': instance.cijena,
      'vrstaProizvodaId': instance.vrstaProizvodaId,
      'opis': instance.opis,
      'restoranId': instance.restoranId,
      'vrstaProizvoda': instance.vrstaProizvoda,
      'restoran': instance.restoran,
      'isDeleted': instance.isDeleted,
    };
