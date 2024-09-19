import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:natanjir_mobile/models/ocjena_restoran.dart';
import 'package:natanjir_mobile/models/restoran.dart';
import 'package:natanjir_mobile/models/restoran_favorit.dart';
import 'package:natanjir_mobile/models/search_result.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/ocjena_restoran_provider.dart';
import 'package:natanjir_mobile/providers/restoran_favorit_provider.dart';
import 'package:natanjir_mobile/providers/restoran_provider.dart';
import 'package:natanjir_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class RestoranFavoritListScreen extends StatefulWidget {
  const RestoranFavoritListScreen({super.key});

  @override
  State<RestoranFavoritListScreen> createState() =>
      _RestoranFavoritListScreenState();
}

class _RestoranFavoritListScreenState extends State<RestoranFavoritListScreen> {
  late RestoranFavoritProvider restoranFavoritProvider;
  late OcjenaRestoranProvider ocjenaRestoranProvider;

  SearchResult<RestoranFavorit>? restoranFavoritResult;
  SearchResult<OcjenaRestoran>? ocjenaRestoranResult;
  Map<String, dynamic> searchRequest = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    searchRequest = {
      'isKorisnikIncluded': true,
      'isRestoranIncluded': true,
    };
    restoranFavoritProvider = context.read<RestoranFavoritProvider>();
    ocjenaRestoranProvider = context.read<OcjenaRestoranProvider>();
    _initForm();
  }

  Future _initForm() async {
    restoranFavoritResult =
        await restoranFavoritProvider.get(filter: searchRequest);
    ocjenaRestoranResult = await ocjenaRestoranProvider.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 83, 86),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Restorani favoriti",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildPage(),
        ],
      ),
    );
  }

  Widget _buildPage() {
    if (restoranFavoritResult == null) {
      return Center(child: CircularProgressIndicator());
    }
    if (restoranFavoritResult!.result
        .where((element) => element.korisnikId == AuthProvider.korisnikId)
        .isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 83, 86),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Nemate restorane u koje ste dodali favorite!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: restoranFavoritResult!.result
            .where((element) => element.korisnikId == AuthProvider.korisnikId)
            .map(
              (e) => Container(
                height: 95,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(vertical: 8.0),
                width: double.infinity,
                child: Slidable(
                  startActionPane: ActionPane(
                    motion: BehindMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          await restoranFavoritProvider
                              .delete(e.restoranFavoritId!);
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              title:
                                  "Restoran je uspješno obrisan iz favorita.");

                          restoranFavoritResult = await restoranFavoritProvider
                              .get(filter: searchRequest);
                          setState(() {});
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: 'Obriši',
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 120,
                            height: 100,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: e.restoran!.slika != null &&
                                        e.restoran!.slika!.isNotEmpty
                                    ? imageFromString(e.restoran!.slika!)
                                    : Image.asset(
                                        "assets/images/restoranImg.png",
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  e.restoran!.naziv ?? "",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  e.restoran!.lokacija ?? "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(1.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.yellow),
                                      Expanded(
                                        child: Text(
                                          "${_avgOcjena(e.restoranId).toString()}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color.fromARGB(
                                                255, 108, 108, 108),
                                            fontWeight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  dynamic _avgOcjena(int? restoranId) {
    var ocjenaRestoran = ocjenaRestoranResult!.result
        .where((e) => e.restoranId == restoranId)
        .toList();
    if (ocjenaRestoran.isEmpty) {
      return 0;
    }

    double avgOcjena =
        ocjenaRestoran.map((e) => e?.ocjena ?? 0).reduce((a, b) => a + b) /
            ocjenaRestoran.length;
    return formatNumber(avgOcjena);
  }
}
