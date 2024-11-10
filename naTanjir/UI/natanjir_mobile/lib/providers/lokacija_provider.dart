import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:natanjir_mobile/models/lokacija.dart';
import 'package:natanjir_mobile/providers/base_provider.dart';

class LokacijaProvider extends BaseProvider<Lokacija> {
  LokacijaProvider() : super("Lokacija");

  @override
  Lokacija fromJson(data) {
    return Lokacija.fromJson(data);
  }
}
