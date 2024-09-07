import 'package:json_annotation/json_annotation.dart';
part 'vrsta_proizvodum.g.dart';

@JsonSerializable()
class VrstaProizvodum {
  int? vrstaId;
  String? naziv;

  VrstaProizvodum();

  factory VrstaProizvodum.fromJson(Map<String, dynamic> json) =>
      _$VrstaProizvodumFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$VrstaProizvodumToJson(this);
}
