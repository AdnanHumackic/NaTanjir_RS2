import 'package:json_annotation/json_annotation.dart';
part 'ocjena_proizvod.g.dart';

@JsonSerializable()
class OcjenaProizvod {
  int? ocjenaProizvodId;
  String? datumKreiranja;
  double? ocjena;
  int? proizvodId;
  int? korisnikId;

  OcjenaProizvod();

  factory OcjenaProizvod.fromJson(Map<String, dynamic> json) =>
      _$OcjenaProizvodFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$OcjenaProizvodToJson(this);
}
