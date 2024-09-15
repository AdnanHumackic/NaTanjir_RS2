import 'package:json_annotation/json_annotation.dart';
import 'package:natanjir_mobile/models/korisnici.dart';
import 'package:natanjir_mobile/models/restoran.dart';
part 'restoran_favorit.g.dart';

@JsonSerializable()
class RestoranFavorit {
  int? restoranFavoritId;
  String? datumDodavanja;
  int? korisnikId;
  int? restoranId;
  Korisnici? korisnik;
  Restoran? restoran;
  bool? isFavorit;

  RestoranFavorit();

  factory RestoranFavorit.fromJson(Map<String, dynamic> json) =>
      _$RestoranFavoritFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RestoranFavoritToJson(this);
}
