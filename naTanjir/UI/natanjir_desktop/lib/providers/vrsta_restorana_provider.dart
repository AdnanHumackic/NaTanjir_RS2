import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:natanjir_desktop/models/proizvod.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/vrsta_proizvodum.dart';
import 'package:natanjir_desktop/models/vrsta_restorana.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:natanjir_desktop/providers/base_provider.dart';

class VrstaRestoranaProvider extends BaseProvider<VrstaRestorana> {
  VrstaRestoranaProvider() : super("VrstaRestorana");

  @override
  VrstaRestorana fromJson(data) {
    return VrstaRestorana.fromJson(data);
  }
}
