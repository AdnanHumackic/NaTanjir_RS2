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

  Future ponisti(int rezervacijaId) async {
    var url = "${BaseProvider.baseUrl}Narudzba/${rezervacijaId}/ponisti";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
  }
}
