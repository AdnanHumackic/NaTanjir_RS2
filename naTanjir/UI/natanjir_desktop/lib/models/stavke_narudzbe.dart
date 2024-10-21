import 'package:json_annotation/json_annotation.dart';
import 'package:natanjir_desktop/models/korisnici.dart';
import 'package:natanjir_desktop/models/narudzba.dart';
import 'package:natanjir_desktop/models/proizvod.dart';
import 'package:natanjir_desktop/models/restoran.dart';

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
  Proizvod? proizvod;
  Restoran? restoran;
  StavkeNarudzbe();

  factory StavkeNarudzbe.fromJson(Map<String, dynamic> json) =>
      _$StavkeNarudzbeFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$StavkeNarudzbeToJson(this);
}
