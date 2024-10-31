import 'package:json_annotation/json_annotation.dart';
import 'package:natanjir_desktop/models/vrsta_restorana.dart';
part 'restoran.g.dart';

@JsonSerializable()
class Restoran {
  int? restoranId;
  String? naziv;
  String? radnoVrijemeOd;
  String? radnoVrijemeDo;
  String? slika;
  String? lokacija;
  int? vrstaRestoranaId;
  int? vlasnikId;
  bool? isDeleted;
  VrstaRestorana? vrstaRestorana;
  Restoran();
  factory Restoran.fromJson(Map<String, dynamic> json) =>
      _$RestoranFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RestoranToJson(this);
}
