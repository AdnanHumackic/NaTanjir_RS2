import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:natanjir_mobile/models/stavke_narudzbe.dart';
import 'package:natanjir_mobile/providers/base_provider.dart';

class StavkeNarudzbeProvider extends BaseProvider<StavkeNarudzbe> {
  StavkeNarudzbeProvider() : super("StavkeNarudzbe");

  @override
  StavkeNarudzbe fromJson(data) {
    return StavkeNarudzbe.fromJson(data);
  }
}
