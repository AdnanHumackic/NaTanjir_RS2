import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:natanjir_mobile/models/narudzba.dart';
import 'package:natanjir_mobile/providers/base_provider.dart';

class NarudzbaProvider extends BaseProvider<Narudzba> {
  NarudzbaProvider() : super("Narudzba");

  @override
  Narudzba fromJson(data) {
    return Narudzba.fromJson(data);
  }

  Future ponisti(int narudzbaId) async {
    var url = "${BaseProvider.baseUrl}Narudzba/${narudzbaId}/ponisti";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
  }

  Future preuzmi(int narudzbaId, int dostavljacId) async {
    var url =
        "${BaseProvider.baseUrl}Narudzba/${narudzbaId}/preuzmi/${dostavljacId}";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
  }

  Future uToku(int narudzbaId) async {
    var url = "${BaseProvider.baseUrl}Narudzba/${narudzbaId}/uToku";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
  }

  Future zavrsi(int narudzbaId) async {
    var url = "${BaseProvider.baseUrl}Narudzba/${narudzbaId}/zavrsi";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
  }

  Future<List<String>> getAllowedActions(int narudzbaId) async {
    var url = "${BaseProvider.baseUrl}Narudzba/${narudzbaId}/allowedActions";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      List<dynamic> data = jsonDecode(response.body);
      return data.cast<String>();
    }
    throw new Exception("Greška");
  }
}
