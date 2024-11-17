import 'package:natanjir_desktop/models/korisnik_uloga.dart';

class AuthProvider {
  static String? username;
  static String? password;
  static int? korisnikId;
  static String? ime;
  static String? prezime;
  static String? email;
  static String? telefon;
  static String? datumRodjenja;
  static String? slika;
  static int? restoranId;
  static List<KorisnikUloga>? korisnikUloge;
  static String? connectionId;
  static bool isSignedIn = false;
}
