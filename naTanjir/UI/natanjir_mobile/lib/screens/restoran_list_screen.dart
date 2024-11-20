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
import 'package:natanjir_mobile/screens/korisnik_profile_edit_screen.dart';
import 'package:natanjir_mobile/screens/korisnik_profile_screen.dart';
import 'package:natanjir_mobile/screens/product_details_screen.dart';
import 'package:natanjir_mobile/screens/registracija_screen.dart';
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

  List<Restoran> restoranList = [];
  int page = 1;

  final int limit = 20;
  int total = 0;
  bool isFirstLoadRunning = false;
  bool hasNextPage = true;
  bool showbtn = false;

  bool isLoadMoreRunning = false;
  late ScrollController scrollController = ScrollController();

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
    _firstLoad();
    scrollController.addListener(() {
      double showoffset = 10.0;

      if (scrollController.offset > showoffset) {
        showbtn = true;
        setState(() {});
      } else {
        showbtn = false;
        setState(() {});
      }
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        _loadMore();
      }
    });

    _initForm();
  }

  void _firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
      restoranList = [];
      page = 1;
      hasNextPage = true;
      isLoadMoreRunning = false;
    });

    var restoranResult = await restoranProvider.get(
      page: page,
      pageSize: 10,
    );

    restoranList = restoranResult!.result;
    total = restoranResult!.count;

    setState(() {
      isFirstLoadRunning = false;
      total = restoranResult!.count;
      if (10 * page > total) {
        hasNextPage = false;
      }
    });
  }

  void _loadMore() async {
    if (hasNextPage &&
        !isFirstLoadRunning &&
        !isLoadMoreRunning &&
        scrollController.position.extentAfter < 300) {
      setState(() {
        isLoadMoreRunning = true;
      });

      try {
        page += 1;

        var restoranResult = await restoranProvider.get(
          page: page,
          pageSize: 10,
        );

        if (restoranResult?.result.isNotEmpty ?? false) {
          setState(() {
            restoranList.addAll(restoranResult!.result);
          });
        } else {
          setState(() {
            hasNextPage = false;
          });
        }
      } catch (e) {
      } finally {
        setState(() {
          isLoadMoreRunning = false;
        });
      }
    }
  }

  Future _initForm() async {
    //restoranResult = await restoranProvider.get();
    vrstaRestoranaResult = await vrstaRestoranaProvider.get();
    ocjenaRestoranResult = await ocjenaRestoranProvider.get();
    restoranfavoritResult = await restoranfavoritProvider.get();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            _buildHeader(),
            _buildSearch(),
            _buildPage(),
          ],
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        opacity: showbtn ? 1.0 : 0.0,
        child: FloatingActionButton(
          onPressed: () {
            scrollController.animateTo(0,
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          },
          child: Icon(
            Icons.arrow_upward,
            color: Colors.white,
          ),
          backgroundColor: Color.fromARGB(255, 0, 83, 86),
        ),
      ),
    );
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
                    if (AuthProvider.korisnikId == null)
                      Positioned(
                        right: 0,
                        child: SizedBox(
                          width: 105,
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegistracijaScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 0, 83, 86),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Registruj se",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    if (AuthProvider.korisnikId != null)
                      Positioned(
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      KorisnikProfileScreen()),
                            ).then((value) {
                              if (value == true) {
                                setState(() {});
                              }
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              width: 50,
                              height: 40,
                              child: AuthProvider.slika != null
                                  ? imageFromString(AuthProvider.slika!)
                                  : Image.asset(
                                      "assets/images/noProfileImg.png",
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
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
    if (restoranList == null) {
      return Center(child: CircularProgressIndicator());
    }
    if (restoranList.isEmpty) {
      return Center(
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            color: Color.fromARGB(97, 158, 158, 158),
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
              "Nema rezultata vaše pretrage.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            ...restoranList!
                .where((x) => x.isDeleted == false)
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
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
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
                                InkWell(
                                  child: (restoranfavoritResult != null &&
                                          restoranfavoritResult!.result !=
                                              null &&
                                          restoranfavoritResult!.result.any(
                                              (f) =>
                                                  f.korisnikId ==
                                                      AuthProvider.korisnikId &&
                                                  f.restoranId == e.restoranId))
                                      ? Icon(Icons.favorite, color: Colors.red)
                                      : Icon(Icons.favorite_border),
                                  onTap: () async {
                                    if (AuthProvider.korisnikId == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 1),
                                          content: Center(
                                            child: Text(
                                              "Morate biti prijavljeni da biste dodali restoran u favorite.",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    if (restoranfavoritResult != null &&
                                        restoranfavoritResult!.result != null) {
                                      bool isFavorite = restoranfavoritResult!
                                          .result
                                          .any((f) =>
                                              f.korisnikId ==
                                                  AuthProvider.korisnikId &&
                                              f.restoranId == e.restoranId);

                                      setState(() {
                                        isFavorite = !isFavorite;
                                      });

                                      if (isFavorite) {
                                        var restFavInsert = {
                                          'korisnikId': AuthProvider.korisnikId,
                                          'restoranId': e.restoranId
                                        };
                                        await restoranfavoritProvider
                                            .insert(restFavInsert);
                                      } else {
                                        var favRest = restoranfavoritResult!
                                            .result
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
                                    }
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
            if (hasNextPage) CircularProgressIndicator(),
            if (!hasNextPage)
              Container(
                width: 250,
                decoration: BoxDecoration(
                  color: Color.fromARGB(97, 158, 158, 158),
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
                    "Nema više restorana za prikazati.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  dynamic _avgOcjena(int? restoranId) {
    if (ocjenaRestoranResult == null || ocjenaRestoranResult!.result == null) {
      return 0;
    }

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
    setState(() {
      isLoadMoreRunning = true;
    });

    var restoranResult = await restoranProvider.get(
      filter: searchRequest,
      pageSize: limit,
      page: 1,
    );

    if (restoranResult != null && restoranResult.result.isNotEmpty) {
      restoranList = restoranResult.result;
    } else {
      restoranList = [];
    }

    setState(() {
      isLoadMoreRunning = false;
    });
  }
}
