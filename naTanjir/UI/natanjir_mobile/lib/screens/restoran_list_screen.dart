import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:natanjir_mobile/layouts/master_screen.dart';
import 'package:natanjir_mobile/models/ocjena_restoran.dart';
import 'package:natanjir_mobile/models/restoran.dart';
import 'package:natanjir_mobile/models/restoran_favorit.dart';
import 'package:natanjir_mobile/models/search_result.dart';
import 'package:natanjir_mobile/models/vrsta_proizvodum.dart';
import 'package:natanjir_mobile/models/vrsta_restorana.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/korisnici_provider.dart';
import 'package:natanjir_mobile/providers/ocjena_restoran_provider.dart';
import 'package:natanjir_mobile/providers/product_provider.dart';
import 'package:natanjir_mobile/providers/restoran_favorit_provider.dart';
import 'package:natanjir_mobile/providers/restoran_provider.dart';
import 'package:natanjir_mobile/providers/utils.dart';
import 'package:natanjir_mobile/providers/vrsta_proizvodum_provider.dart';
import 'package:natanjir_mobile/providers/vrsta_restorana_provider.dart';
import 'package:natanjir_mobile/screens/product_details_screen.dart';
import 'package:natanjir_mobile/screens/restoran_details_screen.dart';
import 'package:provider/provider.dart';

class RestoranListScreen extends StatefulWidget {
  const RestoranListScreen({super.key});

  @override
  State<RestoranListScreen> createState() => _RestoranListScreenState();
}

class _RestoranListScreenState extends State<RestoranListScreen> {
  late RestoranProvider restoranProvider;
  late VrstaRestoranaProvider vrstaRestoranaProvider;
  late OcjenaRestoranProvider ocjenaRestoranProvider;
  late RestoranFavoritProvider restoranfavoritProvider;

  SearchResult<Restoran>? restoranResult;
  SearchResult<VrstaRestorana>? vrstaRestoranaResult;
  SearchResult<OcjenaRestoran>? ocjenaRestoranResult;
  SearchResult<RestoranFavorit>? restoranfavoritResult;

  Map<String, dynamic> searchRequest = {};
  var restFavInsert = {};
  bool isFavorit = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    restoranProvider = context.read<RestoranProvider>();
    vrstaRestoranaProvider = context.read<VrstaRestoranaProvider>();
    ocjenaRestoranProvider = context.read<OcjenaRestoranProvider>();
    restoranfavoritProvider = context.read<RestoranFavoritProvider>();
    _initForm();
  }

  Future _initForm() async {
    restoranResult = await restoranProvider.get();
    vrstaRestoranaResult = await vrstaRestoranaProvider.get();
    ocjenaRestoranResult = await ocjenaRestoranProvider.get();
    restoranfavoritResult = await restoranfavoritProvider.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      _buildHeader(),
      _buildSearch(),
      _buildPage(),
    ]));
  }

  Widget _buildHeader() {
    return Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: SizedBox(
                        width: 105,
                        height: 35,
                        child: Image.asset(
                          "assets/images/naTanjirLogoMini.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: InkWell(
                          onTap: () {
                            //TODO: navigate to profile edit screen
                          },
                          child: SizedBox(
                              width: 50,
                              height: 40,
                              child: AuthProvider.slika != null
                                  ? imageFromString(AuthProvider.slika!)
                                  : Image.asset(
                                      "assets/images/noProfileImg.png",
                                      fit: BoxFit.fill,
                                    ))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
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
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchRequest['nazivGte'] = value;
                  _loadFiltered();
                });
              },
              decoration: InputDecoration(
                hintText: "Naziv restorana",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: MultiSelectChipField(
              showHeader: false,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              selectedChipColor: Color.fromARGB(255, 0, 83, 86),
              textStyle: TextStyle(
                color: Color.fromARGB(173, 0, 0, 0),
                fontSize: 15,
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              items: (vrstaRestoranaResult?.result.isNotEmpty == true
                  ? vrstaRestoranaResult!.result
                      .map((e) => MultiSelectItem<int>(
                            e.vrstaId ?? 0,
                            e.naziv ?? "",
                          ))
                      .toList()
                  : []),
              scrollBar: HorizontalScrollBar(isAlwaysShown: false),
              onTap: (value) {
                setState(() {
                  searchRequest['vrstaRestoranaId'] = value;
                  _loadFiltered();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage() {
    if (restoranResult == null) {
      return Center(child: CircularProgressIndicator());
    }
    if (restoranResult!.count == 0) {
      return Center(
        child: Container(
          width: 250,
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
              "Nema rezultata vaše pretrage!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: restoranResult!.result
            .map(
              (e) => GestureDetector(
                onTap: () async {
                  dynamic avgOcj = _avgOcjena(e.restoranId).toString();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RestoranDetailsScreen(
                          odabraniRestoran: e, avgOcjena: avgOcj)));
                },
                child: Container(
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
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                            child: e.slika != null && e.slika!.isNotEmpty
                                ? imageFromString(e.slika!)
                                : Image.asset(
                                    "assets/images/restoranImg.png",
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.naziv ?? "",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.yellow, size: 16),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      _avgOcjena(e.restoranId).toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color:
                                            Color.fromARGB(255, 108, 108, 108),
                                        fontWeight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                                child: restoranfavoritResult!.result.any((f) =>
                                        f.korisnikId ==
                                            AuthProvider.korisnikId &&
                                        f.restoranId == e.restoranId)
                                    ? Icon(Icons.favorite, color: Colors.red)
                                    : Icon(Icons.favorite_border),
                                onTap: () async {
                                  bool isFavorite =
                                      restoranfavoritResult!.result.any((f) =>
                                          f.korisnikId ==
                                              AuthProvider.korisnikId &&
                                          f.restoranId == e.restoranId);

                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });

                                  if (isFavorite) {
                                    restFavInsert = {
                                      'korisnikId': AuthProvider.korisnikId,
                                      'restoranId': e.restoranId
                                    };
                                    await restoranfavoritProvider
                                        .insert(restFavInsert);
                                  } else {
                                    var favRest = restoranfavoritResult!.result
                                        .firstWhere((f) =>
                                            f.korisnikId ==
                                                AuthProvider.korisnikId &&
                                            f.restoranId == e.restoranId);
                                    await restoranfavoritProvider
                                        .delete(favRest.restoranFavoritId!);
                                  }

                                  restoranfavoritResult =
                                      await restoranfavoritProvider.get();
                                  setState(() {});
                                })
                          ],
                        ),
                      )
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

  void _loadFiltered() async {
    if (restoranResult != null) {
      restoranResult = await restoranProvider.get(filter: searchRequest);
    }
    setState(() {});
  }
}
