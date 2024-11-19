import 'dart:convert';

import 'package:natanjir_mobile/models/korisnici.dart';
import 'package:natanjir_mobile/models/proizvod.dart';
import 'package:natanjir_mobile/providers/base_provider.dart';
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

  Future<List<Proizvod>> getRecommended(int korisnikId, int restoranId) async {
    var url =
        "${BaseProvider.baseUrl}Korisnici/${korisnikId}/${restoranId}/recommended";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (response.body.isEmpty || response.body == 'null') {
      return [];
    }
    if (isValidResponse(response)) {
      var data = json.decode(response.body);

      if (data is List) {
        List<Proizvod> dataList =
            data.map((item) => Proizvod.fromJson(item)).toList();
        return dataList;
      } else {
        throw new UserException("Greška");
      }
    }
    throw new UserException("Greška");
  }
}
