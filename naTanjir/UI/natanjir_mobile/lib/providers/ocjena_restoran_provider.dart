import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:natanjir_mobile/models/ocjena_restoran.dart';
import 'package:natanjir_mobile/models/proizvod.dart';
import 'package:natanjir_mobile/models/search_result.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/base_provider.dart';

class OcjenaRestoranProvider extends BaseProvider<OcjenaRestoran> {
  OcjenaRestoranProvider() : super("OcjenaRestoran");

  @override
  OcjenaRestoran fromJson(data) {
    return OcjenaRestoran.fromJson(data);
  }
}
