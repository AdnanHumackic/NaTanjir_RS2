import 'package:json_annotation/json_annotation.dart';
import 'package:natanjir_desktop/models/korisnik_uloga.dart';
part 'korisnici.g.dart';

@JsonSerializable()
class Korisnici {
  int? korisnikId;
  String? ime;
  String? prezime;
  String? email;
  String? telefon;
  String? korisnickoIme;
  String? datumRodjenja;
  String? slika;
  List<KorisnikUloga>? korisniciUloges;

  Korisnici();

  factory Korisnici.fromJson(Map<String, dynamic> json) =>
      _$KorisniciFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KorisniciToJson(this);
}
