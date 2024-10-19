import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/horizontal_scrollbar.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:natanjir_mobile/models/narudzba.dart';
import 'package:natanjir_mobile/models/search_result.dart';
import 'package:natanjir_mobile/models/stavke_narudzbe.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/narudzba_provider.dart';
import 'package:natanjir_mobile/providers/stavke_narudzbe_provider.dart';
import 'package:natanjir_mobile/providers/utils.dart';
import 'package:natanjir_mobile/screens/detalji_narudzbe_screen.dart';
import 'package:provider/provider.dart';

class NarudzbeListScreen extends StatefulWidget {
  const NarudzbeListScreen({super.key});

  @override
  State<NarudzbeListScreen> createState() => _NarudzbeListScreenState();
}

class _NarudzbeListScreenState extends State<NarudzbeListScreen>
    with SingleTickerProviderStateMixin {
  late NarudzbaProvider narudzbaProvider;

  //SearchResult<Narudzba>? narudzbaResult;
  Map<String, dynamic> searchRequest = {};
  List<Narudzba> narudzbaList = [];

  int page = 1;

  final int limit = 20;
  int total = 0;
  bool isFirstLoadRunning = false;
  bool hasNextPage = true;
  bool showbtn = false;
  late TabController _tabController;
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
      'isStavkeNarudzbeIncluded': true,
      'korisnikId': AuthProvider.korisnikId,
    };

    _tabController = TabController(length: 2, vsync: this);
    narudzbaProvider = context.read<NarudzbaProvider>();

    _firstLoad();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _firstLoad();
        showbtn = false;
      }
    });

    scrollController.addListener(() {
      double showOffset = 10.0;
      if (scrollController.offset > showOffset) {
        showbtn = true;
      } else {
        showbtn = false;
      }
      setState(() {});

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
      narudzbaList = [];
      page = 1;
      hasNextPage = true;
      isLoadMoreRunning = false;
    });
    searchRequest['stateMachine'] =
        _tabController.index == 0 ? 'kreirana' : 'preuzeta';

    var narudzbaResult = await narudzbaProvider.get(
      filter: searchRequest,
      page: page,
      pageSize: 10,
      orderBy: 'DatumKreiranja',
      sortDirection: 'desc',
    );

    narudzbaList = narudzbaResult!.result;
    total = narudzbaResult!.count;

    setState(() {
      isFirstLoadRunning = false;
      total = narudzbaResult!.count;
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
        searchRequest['stateMachine'] =
            _tabController.index == 0 ? 'kreirana' : 'preuzeta';

        var narudzbaResult = await narudzbaProvider.get(
          filter: searchRequest,
          page: page,
          pageSize: 10,
          orderBy: 'DatumKreiranja',
          sortDirection: 'desc',
        );

        if (narudzbaResult?.result.isNotEmpty ?? false) {
          setState(() {
            narudzbaList.addAll(narudzbaResult!.result);
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
    // narudzbaResult = await narudzbaProvider.get(
    //     orderBy: 'DatumKreiranja', sortDirection: 'desc');
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: "Aktivne"),
                  Tab(text: "Preuzete"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
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
                    "Vaše narudžbe",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildAktivne(), _buildPreuzete()],
              ),
            ),
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

  Widget _buildAktivne() {
    if (narudzbaList == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (narudzbaList!
        .where((element) =>
            element.stateMachine == "kreirana" &&
            element.korisnikId == AuthProvider.korisnikId)
        .isEmpty) {
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
              "Nemate trenutno aktivnih narudžbi.",
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
      controller: scrollController,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Color.fromARGB(97, 158, 158, 158),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Napomena: Narudžbu možete otkazati u roku od 3 minute nakon kreiranja.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          ...narudzbaList!
              .map(
                (e) => InkWell(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DetaljiNarudzbeScreen(narudzba: e)));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 135,
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
                    child: Slidable(
                      startActionPane: ActionPane(
                        motion: BehindMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              String? datumKreiranja = e.datumKreiranja;
                              var dateNow = DateTime.now();
                              if (datumKreiranja != null) {
                                DateTime datum = DateTime.parse(datumKreiranja);
                                if (dateNow.difference(datum).inMinutes < 3) {
                                  await narudzbaProvider.ponisti(e.narudzbaId!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Color.fromARGB(255, 0, 83, 86),
                                      duration: Duration(seconds: 1),
                                      content: Center(
                                        child: Text(
                                            "Narudžba je uspješno poništena."),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2),
                                      content: Center(
                                        child: Text(
                                          "Prošlo je 3 minute od kreiranja narudžbe, te je ne možete poništiti.",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              } else {}

                              var narudzbaResult = await narudzbaProvider.get(
                                filter: searchRequest,
                                pageSize: limit,
                                page: 1,
                              );

                              if (narudzbaResult != null &&
                                  narudzbaResult.result.isNotEmpty) {
                                narudzbaList = narudzbaResult.result;
                              } else {
                                narudzbaList = [];
                              }
                              setState(() {});
                            },
                            backgroundColor: Colors.red,
                            icon: Icons.close,
                            label: 'Otkaži',
                          ),
                        ],
                      ),
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
                                    child: Image.asset(
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
                                    "Broj narudžbe: #${e.brojNarudzbe}",
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
                                        Expanded(
                                          child: Text(
                                            "Plaćeno: ${formatNumber(e.ukupnaCijena)} KM",
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
                                    "Datum kreiranja: \n${formatDateTime(e.datumKreiranja.toString())}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 108, 108, 108),
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
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
                  "Nema više narudžbi za prikazati.",
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

  Widget _buildPreuzete() {
    if (narudzbaList == null) {
      return Center(child: CircularProgressIndicator());
    }
    if (narudzbaList!
        .where((element) =>
            element.stateMachine == "preuzeta" &&
            element.korisnikId == AuthProvider.korisnikId)
        .isEmpty) {
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
              "Nemate preuzetih narudžbi.",
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
      controller: scrollController,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          ...narudzbaList!
              .map(
                (e) => InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            DetaljiNarudzbeScreen(narudzba: e)));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 135,
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
                                  child: Image.asset(
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
                                  "Broj narudžbe: #${e.brojNarudzbe}",
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
                                      Expanded(
                                        child: Text(
                                          "Plaćeno: ${formatNumber(e.ukupnaCijena)} KM",
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
                                  "Datum kreiranja: \n${formatDateTime(e.datumKreiranja.toString())}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 108, 108, 108),
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
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
                  "Nema više narudžbi za prikazati.",
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
}
