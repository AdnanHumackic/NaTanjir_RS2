import 'package:json_annotation/json_annotation.dart';
import 'package:natanjir_mobile/models/korisnici.dart';
import 'package:natanjir_mobile/models/narudzba.dart';
import 'package:natanjir_mobile/models/proizvod.dart';
import 'package:natanjir_mobile/models/restoran.dart';

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
