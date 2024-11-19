import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:natanjir_mobile/models/proizvod.dart';
import 'package:natanjir_mobile/models/search_result.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/base_provider.dart';

class ProductProvider extends BaseProvider<Proizvod> {
  ProductProvider() : super("Proizvodi");

  @override
  Proizvod fromJson(data) {
    return Proizvod.fromJson(data);
  }

  Future<List<Proizvod>> getRecommendedProducts(int proizvodId) async {
    var url = "${BaseProvider.baseUrl}Proizvodi/${proizvodId}/recommended";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (response.body.isEmpty || response.body == 'null') {
      return [];
    }
    if (isValidResponse(response)) {
      var data = json.decode(response.body);

      if (data is List) {
        List<Proizvod> dataList =
            data.map((item) => Proizvod.fromJson(item)).toList();
        return dataList;
      } else {
        throw new UserException("Greška");
      }
    }
    throw new UserException("Greška");
  }
}
