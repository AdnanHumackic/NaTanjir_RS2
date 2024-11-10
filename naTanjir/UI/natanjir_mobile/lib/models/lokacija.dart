import 'package:json_annotation/json_annotation.dart';
part 'lokacija.g.dart';

@JsonSerializable()
class Lokacija {
  int? lokacijaId;
  int? korisnikId;
  String? adresa;
  double? geografskaDuzina;
  double? geografskaSirina;
  Lokacija();

  factory Lokacija.fromJson(Map<String, dynamic> json) =>
      _$LokacijaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LokacijaToJson(this);
}
