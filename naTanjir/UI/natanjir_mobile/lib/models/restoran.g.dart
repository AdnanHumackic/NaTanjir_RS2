// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restoran.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restoran _$RestoranFromJson(Map<String, dynamic> json) => Restoran()
  ..restoranId = (json['restoranId'] as num?)?.toInt()
  ..naziv = json['naziv'] as String?
  ..radnoVrijemeOd = json['radnoVrijemeOd'] as String?
  ..radnoVrijemeDo = json['radnoVrijemeDo'] as String?
  ..slika = json['slika'] as String?
  ..lokacija = json['lokacija'] as String?
  ..vrstaRestoranaId = (json['vrstaRestoranaId'] as num?)?.toInt()
  ..vlasnikId = (json['vlasnikId'] as num?)?.toInt()
  ..isDeleted = json['isDeleted'] as bool?
  ..vrstaRestorana = json['vrstaRestorana'] == null
      ? null
      : VrstaRestorana.fromJson(json['vrstaRestorana'] as Map<String, dynamic>);

Map<String, dynamic> _$RestoranToJson(Restoran instance) => <String, dynamic>{
      'restoranId': instance.restoranId,
      'naziv': instance.naziv,
      'radnoVrijemeOd': instance.radnoVrijemeOd,
      'radnoVrijemeDo': instance.radnoVrijemeDo,
      'slika': instance.slika,
      'lokacija': instance.lokacija,
      'vrstaRestoranaId': instance.vrstaRestoranaId,
      'vlasnikId': instance.vlasnikId,
      'isDeleted': instance.isDeleted,
      'vrstaRestorana': instance.vrstaRestorana,
    };
