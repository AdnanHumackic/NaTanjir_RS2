import 'package:json_annotation/json_annotation.dart';
import 'package:natanjir_mobile/models/korisnici.dart';
import 'package:natanjir_mobile/models/stavke_narudzbe.dart';
part 'narudzba.g.dart';

@JsonSerializable()
class Narudzba {
  int? narudzbaId;
  int? brojNarudzbe;
  double? ukupnaCijena;
  String? datumKreiranja;
  String? stateMachine;
  int? korisnikId;
  Korisnici? korisnik;
  int? dostavljacId;
  List<StavkeNarudzbe>? stavkeNarudzbe;

  Narudzba();

  factory Narudzba.fromJson(Map<String, dynamic> json) =>
      _$NarudzbaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$NarudzbaToJson(this);
}
