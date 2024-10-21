// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocjena_restoran.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OcjenaRestoran _$OcjenaRestoranFromJson(Map<String, dynamic> json) =>
    OcjenaRestoran()
      ..ocjenaRestoranId = (json['ocjenaRestoranId'] as num?)?.toInt()
      ..datum = json['datum'] as String?
      ..ocjena = (json['ocjena'] as num?)?.toDouble()
      ..restoranId = (json['restoranId'] as num?)?.toInt()
      ..korisnikId = (json['korisnikId'] as num?)?.toInt();

Map<String, dynamic> _$OcjenaRestoranToJson(OcjenaRestoran instance) =>
    <String, dynamic>{
      'ocjenaRestoranId': instance.ocjenaRestoranId,
      'datum': instance.datum,
      'ocjena': instance.ocjena,
      'restoranId': instance.restoranId,
      'korisnikId': instance.korisnikId,
    };
