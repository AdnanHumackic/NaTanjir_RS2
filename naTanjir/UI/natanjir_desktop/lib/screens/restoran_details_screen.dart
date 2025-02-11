import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/horizontal_scrollbar.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/ocjena_proizvod.dart';
import 'package:natanjir_desktop/models/ocjena_restoran.dart';
import 'package:natanjir_desktop/models/proizvod.dart';
import 'package:natanjir_desktop/models/restoran.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/vrsta_proizvodum.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:natanjir_desktop/providers/base_provider.dart';
import 'package:natanjir_desktop/providers/ocjena_proizvod_provider.dart';
import 'package:natanjir_desktop/providers/ocjena_restoran_provider.dart';
import 'package:natanjir_desktop/providers/product_provider.dart';
import 'package:natanjir_desktop/providers/utils.dart';
import 'package:natanjir_desktop/providers/vrsta_proizvodum_provider.dart';
import 'package:natanjir_desktop/screens/proizvod_details_screen.dart';
import 'package:provider/provider.dart';

class RestoranDetailsScreen extends StatefulWidget {
  Restoran? odabraniRestoran;
  dynamic avgOcjena;
  RestoranDetailsScreen(
      {super.key, required this.odabraniRestoran, required this.avgOcjena});

  @override
  State<RestoranDetailsScreen> createState() => _RestoranDetailsScreenState();
}

class _RestoranDetailsScreenState extends State<RestoranDetailsScreen> {
  late ProductProvider proizvodProvider;
  late VrstaProizvodumProvider vrstaProizvodumProvider;
  late OcjenaProizvodProvider ocjenaProizvodProvider;
  late OcjenaRestoranProvider ocjenaRestoranProvider;

  //SearchResult<Proizvod>? proizvodResult;
  SearchResult<VrstaProizvodum>? vrstaProizvodumResult;
  SearchResult<OcjenaProizvod>? ocjenaProizvodResult;
  SearchResult<OcjenaRestoran>? ocjenaRestoranResult;

  Map<String, dynamic> searchRequest = {};

  List<Proizvod> proizvodList = [];
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
    searchRequest = {
      'restoranId': widget.odabraniRestoran!.restoranId,
    };
    proizvodProvider = context.read<ProductProvider>();
    vrstaProizvodumProvider = context.read<VrstaProizvodumProvider>();
    ocjenaProizvodProvider = context.read<OcjenaProizvodProvider>();
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

  void _firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
      proizvodList = [];
      page = 1;
      hasNextPage = true;
      isLoadMoreRunning = false;
    });

    var proizvodResult = await proizvodProvider.get(
      filter: searchRequest,
      page: page,
      pageSize: 10,
    );

    proizvodList = proizvodResult!.result;
    total = proizvodResult!.count;

    setState(() {
      isFirstLoadRunning = false;
      total = proizvodResult!.count;
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

        var proizvodResult = await proizvodProvider.get(
          filter: searchRequest,
          page: page,
          pageSize: 10,
        );

        if (proizvodResult?.result.isNotEmpty ?? false) {
          setState(() {
            proizvodList.addAll(proizvodResult!.result);
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
    //proizvodResult = await proizvodProvider.get(filter: searchRequest);
    vrstaProizvodumResult = await vrstaProizvodumProvider.get();
    ocjenaProizvodResult = await ocjenaProizvodProvider.get();
    ocjenaRestoranResult = await ocjenaRestoranProvider.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Detalji restorana",
      Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildSearch(),
                    _buildPage(),
                  ],
                ),
              ),
            ),
          ],
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
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.all(10),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: SizedBox(
              width: 90,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: widget.odabraniRestoran!.slika != null &&
                        widget.odabraniRestoran!.slika!.isNotEmpty
                    ? imageFromString(widget.odabraniRestoran!.slika!)
                    : Image.asset(
                        "assets/images/restoranImg.png",
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.odabraniRestoran!.naziv ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  widget.odabraniRestoran!.lokacija ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        "${_avgOcjenaRestoran(widget.odabraniRestoran!.restoranId)}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 108, 108, 108),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 5),
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
                hintText: "Naziv proizvoda",
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
              items: (vrstaProizvodumResult?.result.isNotEmpty == true
                  ? vrstaProizvodumResult!.result
                      .map((e) => MultiSelectItem<int>(
                            e.vrstaId ?? 0,
                            e.naziv ?? "",
                          ))
                      .toList()
                  : []),
              scrollBar: HorizontalScrollBar(isAlwaysShown: false),
              onTap: (value) {
                setState(() {
                  searchRequest['vrstaProizvodaId'] = value;
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
    if (proizvodList == null) {
      return Container(
        margin: EdgeInsets.only(top: 15),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (proizvodList.isEmpty) {
      return Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 15),
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
              "Restoran nema proizvoda u ponudi.",
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
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          ...proizvodList
              .map(
                (e) => GestureDetector(
                  onTap: () async {
                    dynamic avgOcj = _avgOcjena(e.proizvodId).toString();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProizvodDetailsScreen(
                          odabraniProizvod: e,
                          avgOcjena: avgOcj,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 129,
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
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: SizedBox(
                              width: 120,
                              height: 100,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: e!.slika != null && e.slika!.isNotEmpty
                                      ? imageFromString(e.slika!)
                                      : Image.asset(
                                          "assets/images/emptyProductImage.png",
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.naziv ?? "",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(1.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.yellow),
                                      Expanded(
                                        child: Text(
                                          "${_avgOcjena(e.proizvodId)}",
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
                                SizedBox(height: 5),
                                Text(
                                  e.opis ?? "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 108, 108, 108),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${formatNumber(e.cijena)} KM",
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
                  "Nema više proizvoda za prikazati.",
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

  dynamic _avgOcjena(int? proizvodId) {
    if (ocjenaRestoranResult == null || ocjenaRestoranResult!.result == null) {
      return 0;
    }

    var ocjenaProizvod = ocjenaProizvodResult!.result
        .where((e) => e.proizvodId == proizvodId)
        .toList();
    if (ocjenaProizvod.isEmpty) {
      return 0;
    }

    double avgOcjena =
        ocjenaProizvod.map((e) => e?.ocjena ?? 0).reduce((a, b) => a + b) /
            ocjenaProizvod.length;
    return formatNumber(avgOcjena);
  }

  dynamic _avgOcjenaRestoran(int? restoranId) {
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

    var proizvodResult = await proizvodProvider.get(
      filter: searchRequest,
      pageSize: limit,
      page: 1,
    );

    if (proizvodResult != null && proizvodResult.result.isNotEmpty) {
      proizvodList = proizvodResult.result;
    } else {
      proizvodList = [];
    }

    setState(() {
      isLoadMoreRunning = false;
    });
  }
}
