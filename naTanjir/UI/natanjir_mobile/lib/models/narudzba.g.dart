// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Narudzba _$NarudzbaFromJson(Map<String, dynamic> json) => Narudzba()
  ..narudzbaId = (json['narudzbaId'] as num?)?.toInt()
  ..brojNarudzbe = (json['brojNarudzbe'] as num?)?.toInt()
  ..ukupnaCijena = (json['ukupnaCijena'] as num?)?.toDouble()
  ..datumKreiranja = json['datumKreiranja'] as String?
  ..stateMachine = json['stateMachine'] as String?
  ..korisnikId = (json['korisnikId'] as num?)?.toInt()
  ..korisnik = json['korisnik'] == null
      ? null
      : Korisnici.fromJson(json['korisnik'] as Map<String, dynamic>)
  ..dostavljacId = (json['dostavljacId'] as num?)?.toInt()
  ..stavkeNarudzbe = (json['stavkeNarudzbe'] as List<dynamic>?)
      ?.map((e) => StavkeNarudzbe.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$NarudzbaToJson(Narudzba instance) => <String, dynamic>{
      'narudzbaId': instance.narudzbaId,
      'brojNarudzbe': instance.brojNarudzbe,
      'ukupnaCijena': instance.ukupnaCijena,
      'datumKreiranja': instance.datumKreiranja,
      'stateMachine': instance.stateMachine,
      'korisnikId': instance.korisnikId,
      'korisnik': instance.korisnik,
      'dostavljacId': instance.dostavljacId,
      'stavkeNarudzbe': instance.stavkeNarudzbe,
    };
