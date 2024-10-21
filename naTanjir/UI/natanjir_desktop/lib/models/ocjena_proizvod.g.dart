// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocjena_proizvod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OcjenaProizvod _$OcjenaProizvodFromJson(Map<String, dynamic> json) =>
    OcjenaProizvod()
      ..ocjenaProizvodId = (json['ocjenaProizvodId'] as num?)?.toInt()
      ..datumKreiranja = json['datumKreiranja'] as String?
      ..ocjena = (json['ocjena'] as num?)?.toDouble()
      ..proizvodId = (json['proizvodId'] as num?)?.toInt()
      ..korisnikId = (json['korisnikId'] as num?)?.toInt();

Map<String, dynamic> _$OcjenaProizvodToJson(OcjenaProizvod instance) =>
    <String, dynamic>{
      'ocjenaProizvodId': instance.ocjenaProizvodId,
      'datumKreiranja': instance.datumKreiranja,
      'ocjena': instance.ocjena,
      'proizvodId': instance.proizvodId,
      'korisnikId': instance.korisnikId,
    };
