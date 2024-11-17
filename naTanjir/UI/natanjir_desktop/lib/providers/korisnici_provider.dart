import 'dart:convert';

import 'package:natanjir_desktop/models/korisnici.dart';
import 'package:natanjir_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class KorisniciProvider extends BaseProvider<Korisnici> {
  KorisniciProvider() : super("Korisnici");

  @override
  Korisnici fromJson(data) {
    return Korisnici.fromJson(data);
  }

  Future<Korisnici> login(
      String username, String password, String connectionId) async {
    var url =
        "${BaseProvider.baseUrl}Korisnici/login?username=${username}&password=${password}&connectionId=${connectionId}";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response;
    try {
      response = await http.post(uri, headers: headers);
    } on Exception catch (e) {
      throw new UserException("Greška prilikom prijave.");
    }
    if (username.isEmpty || password.isEmpty) {
      throw new UserException("Molimo unesite korisničko ime i lozinku.");
    }
    if (response.body == "") {
      throw new UserException("Pogrešno korisničko ime ili lozinka.");
    }
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new UserException("Unknown error.");
    }
  }
}
