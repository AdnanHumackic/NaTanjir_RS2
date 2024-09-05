import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:natanjir_desktop/models/proizvod.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/vrsta_proizvodum.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:natanjir_desktop/providers/base_provider.dart';

class VrstaProizvodumProvider extends BaseProvider<VrstaProizvodum> {
  VrstaProizvodumProvider() : super("VrstaProizvodum");

  @override
  VrstaProizvodum fromJson(data) {
    return VrstaProizvodum.fromJson(data);
  }
}
