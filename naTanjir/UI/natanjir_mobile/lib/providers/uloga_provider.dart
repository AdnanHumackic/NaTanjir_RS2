import 'package:natanjir_mobile/models/uloga.dart';
import 'package:natanjir_mobile/providers/base_provider.dart';

class UlogeProvider extends BaseProvider<Uloga> {
  UlogeProvider() : super("Uloge");

  @override
  Uloga fromJson(data) {
    // TODO: implement fromJson
    return Uloga.fromJson(data);
  }
}
