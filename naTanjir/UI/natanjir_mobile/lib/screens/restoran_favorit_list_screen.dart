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
import 'package:natanjir_mobile/screens/restoran_details_screen.dart';
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

  //SearchResult<RestoranFavorit>? restoranFavoritResult;
  SearchResult<OcjenaRestoran>? ocjenaRestoranResult;
  Map<String, dynamic> searchRequest = {};

  List<RestoranFavorit> restoranFavoritList = [];
  int page = 1;

  final int limit = 20;
  int total = 0;
  bool isFirstLoadRunning = false;
  bool hasNextPage = true;
  bool showbtn = false;

  bool isLoadMoreRunning = false;
  late ScrollController scrollController = ScrollController();

  void _firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
      restoranFavoritList = [];
      page = 1;
      hasNextPage = true;
      isLoadMoreRunning = false;
    });

    var restoranFavoritResult = await restoranFavoritProvider.get(
      filter: searchRequest,
      page: page,
      pageSize: 10,
    );

    restoranFavoritList = restoranFavoritResult!.result;
    total = restoranFavoritResult!.count;

    setState(() {
      isFirstLoadRunning = false;
      total = restoranFavoritResult!.count;
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

        var restoranfavoritResult = await restoranFavoritProvider.get(
          filter: searchRequest,
          page: page,
          pageSize: 10,
        );

        if (restoranfavoritResult?.result.isNotEmpty ?? false) {
          setState(() {
            restoranFavoritList.addAll(restoranfavoritResult!.result);
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

  Future _initForm() async {
    // restoranFavoritResult =
    //     await restoranFavoritProvider.get(filter: searchRequest);
    ocjenaRestoranResult = await ocjenaRestoranProvider.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
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

  Widget _buildPage() {
    if (restoranFavoritList == null) {
      return Center(child: CircularProgressIndicator());
    }
    if (restoranFavoritList != null &&
        restoranFavoritList
            .where((element) => element.korisnikId == AuthProvider.korisnikId)
            .isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Container(
            margin: EdgeInsets.all(15),
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
        children: [
          ...restoranFavoritList!
              .where((element) =>
                  element.korisnikId == AuthProvider.korisnikId &&
                  element.restoran != null &&
                  element.restoran!.isDeleted == false)
              .map(
                (e) => InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RestoranDetailsScreen(
                            odabraniRestoran: e.restoran,
                            avgOcjena: _avgOcjena(e.restoranId).toString())));
                  },
                  child: Container(
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Color.fromARGB(255, 0, 83, 86),
                                  duration: Duration(seconds: 1),
                                  content: Center(
                                    child: Text(
                                        "Restoran je obrisan iz favorita."),
                                  ),
                                ),
                              );

                              var restoranFavoritResult =
                                  await restoranFavoritProvider.get(
                                filter: searchRequest,
                                pageSize: limit,
                                page: 1,
                              );

                              if (restoranFavoritResult != null &&
                                  restoranFavoritResult.result.isNotEmpty) {
                                restoranFavoritList =
                                    restoranFavoritResult.result;
                              } else {
                                restoranFavoritList = [];
                              }
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
                                      padding: EdgeInsets.all(1),
                                      child: Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.yellow),
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
                  "Nemate više restorana u favoritima za prikazati.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
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
