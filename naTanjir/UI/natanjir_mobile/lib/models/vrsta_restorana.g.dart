// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vrsta_restorana.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VrstaRestorana _$VrstaRestoranaFromJson(Map<String, dynamic> json) =>
    VrstaRestorana()
      ..vrstaId = (json['vrstaId'] as num?)?.toInt()
      ..naziv = json['naziv'] as String?;

Map<String, dynamic> _$VrstaRestoranaToJson(VrstaRestorana instance) =>
    <String, dynamic>{
      'vrstaId': instance.vrstaId,
      'naziv': instance.naziv,
    };
