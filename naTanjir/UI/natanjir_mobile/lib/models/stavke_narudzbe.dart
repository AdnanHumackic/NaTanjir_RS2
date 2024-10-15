import 'package:json_annotation/json_annotation.dart';

part 'stavke_narudzbe.g.dart';

@JsonSerializable()
class StavkeNarudzbe {
  int? stavkeNarudzbeId;
  int? kolicina;
  double? cijena;
  int? narudzbaId;
  int? proizvodId;
  int? korisnikId;
  int? restoranId;

  StavkeNarudzbe();

  factory StavkeNarudzbe.fromJson(Map<String, dynamic> json) =>
      _$StavkeNarudzbeFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$StavkeNarudzbeToJson(this);
}
