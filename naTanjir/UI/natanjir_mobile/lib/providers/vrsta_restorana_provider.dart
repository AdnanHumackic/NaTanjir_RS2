import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:natanjir_mobile/models/proizvod.dart';
import 'package:natanjir_mobile/models/search_result.dart';
import 'package:natanjir_mobile/models/vrsta_proizvodum.dart';
import 'package:natanjir_mobile/models/vrsta_restorana.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/base_provider.dart';

class VrstaRestoranaProvider extends BaseProvider<VrstaRestorana> {
  VrstaRestoranaProvider() : super("VrstaRestorana");

  @override
  VrstaRestorana fromJson(data) {
    return VrstaRestorana.fromJson(data);
  }
}
