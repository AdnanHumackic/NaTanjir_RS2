// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lokacija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lokacija _$LokacijaFromJson(Map<String, dynamic> json) => Lokacija()
  ..lokacijaId = (json['lokacijaId'] as num?)?.toInt()
  ..korisnikId = (json['korisnikId'] as num?)?.toInt()
  ..adresa = json['adresa'] as String?
  ..geografskaDuzina = (json['geografskaDuzina'] as num?)?.toDouble()
  ..geografskaSirina = (json['geografskaSirina'] as num?)?.toDouble();

Map<String, dynamic> _$LokacijaToJson(Lokacija instance) => <String, dynamic>{
      'lokacijaId': instance.lokacijaId,
      'korisnikId': instance.korisnikId,
      'adresa': instance.adresa,
      'geografskaDuzina': instance.geografskaDuzina,
      'geografskaSirina': instance.geografskaSirina,
    };
