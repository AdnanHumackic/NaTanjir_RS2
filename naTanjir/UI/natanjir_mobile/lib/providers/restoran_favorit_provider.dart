import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:natanjir_mobile/models/proizvod.dart';
import 'package:natanjir_mobile/models/restoran.dart';
import 'package:natanjir_mobile/models/restoran_favorit.dart';
import 'package:natanjir_mobile/models/search_result.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/base_provider.dart';

class RestoranFavoritProvider extends BaseProvider<RestoranFavorit> {
  RestoranFavoritProvider() : super("RestoranFavorit");

  @override
  RestoranFavorit fromJson(data) {
    return RestoranFavorit.fromJson(data);
  }
}
