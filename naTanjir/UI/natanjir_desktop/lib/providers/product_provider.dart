import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:natanjir_desktop/models/proizvod.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:natanjir_desktop/providers/base_provider.dart';

class ProductProvider extends BaseProvider<Proizvod> {
  ProductProvider() : super("Proizvodi");

  @override
  Proizvod fromJson(data) {
    return Proizvod.fromJson(data);
  }
}
