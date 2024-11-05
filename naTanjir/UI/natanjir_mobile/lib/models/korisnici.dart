import 'package:json_annotation/json_annotation.dart';
import 'package:natanjir_mobile/models/korisnik_uloga.dart';
import 'package:natanjir_mobile/models/restoran.dart';
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
  bool? isDeleted;
  int? restoranId;
  Restoran? restoran;
  List<KorisnikUloga>? korisniciUloges;

  Korisnici();

  factory Korisnici.fromJson(Map<String, dynamic> json) =>
      _$KorisniciFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KorisniciToJson(this);
}
