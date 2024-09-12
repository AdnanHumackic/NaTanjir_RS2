import 'package:json_annotation/json_annotation.dart';
part 'vrsta_restorana.g.dart';

@JsonSerializable()
class VrstaRestorana {
  int? vrstaId;
  String? naziv;

  VrstaRestorana();

  factory VrstaRestorana.fromJson(Map<String, dynamic> json) =>
      _$VrstaRestoranaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$VrstaRestoranaToJson(this);
}
