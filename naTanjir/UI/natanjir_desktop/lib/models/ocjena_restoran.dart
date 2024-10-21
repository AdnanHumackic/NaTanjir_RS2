import 'package:json_annotation/json_annotation.dart';
part 'ocjena_restoran.g.dart';

@JsonSerializable()
class OcjenaRestoran {
  int? ocjenaRestoranId;
  String? datum;
  double? ocjena;
  int? restoranId;
  int? korisnikId;

  OcjenaRestoran();

  factory OcjenaRestoran.fromJson(Map<String, dynamic> json) =>
      _$OcjenaRestoranFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$OcjenaRestoranToJson(this);
}
