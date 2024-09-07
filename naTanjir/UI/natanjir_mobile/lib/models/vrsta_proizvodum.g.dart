// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vrsta_proizvodum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VrstaProizvodum _$VrstaProizvodumFromJson(Map<String, dynamic> json) =>
    VrstaProizvodum()
      ..vrstaId = (json['vrstaId'] as num?)?.toInt()
      ..naziv = json['naziv'] as String?;

Map<String, dynamic> _$VrstaProizvodumToJson(VrstaProizvodum instance) =>
    <String, dynamic>{
      'vrstaId': instance.vrstaId,
      'naziv': instance.naziv,
    };
