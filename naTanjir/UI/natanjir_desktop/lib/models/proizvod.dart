import 'package:json_annotation/json_annotation.dart';
import 'package:natanjir_desktop/models/restoran.dart';
import 'package:natanjir_desktop/models/vrsta_proizvodum.dart';
part 'proizvod.g.dart';

@JsonSerializable()
class Proizvod {
  int? proizvodId;
  String? naziv;
  String? slika;
  double? cijena;
  int? vrstaProizvodaId;
  String? opis;
  int? restoranId;
  VrstaProizvodum? vrstaProizvoda;
  Restoran? restoran;
  bool? isDeleted;
  Proizvod({this.proizvodId, this.naziv});

  factory Proizvod.fromJson(Map<String, dynamic> json) =>
      _$ProizvodFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ProizvodToJson(this);
}
