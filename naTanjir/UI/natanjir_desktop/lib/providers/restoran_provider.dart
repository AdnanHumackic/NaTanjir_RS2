import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:natanjir_desktop/models/proizvod.dart';
import 'package:natanjir_desktop/models/restoran.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:natanjir_desktop/providers/base_provider.dart';

class RestoranProvider extends BaseProvider<Restoran> {
  RestoranProvider() : super("Restoran");

  @override
  Restoran fromJson(data) {
    return Restoran.fromJson(data);
  }
}
