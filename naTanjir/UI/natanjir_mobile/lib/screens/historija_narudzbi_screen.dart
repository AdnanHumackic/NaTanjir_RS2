import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natanjir_mobile/models/narudzba.dart';
import 'package:natanjir_mobile/models/search_result.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/narudzba_provider.dart';
import 'package:natanjir_mobile/providers/utils.dart';
import 'package:natanjir_mobile/screens/detalji_narudzbe_screen.dart';
import 'package:provider/provider.dart';

class HistorijaNarudzbiScreen extends StatefulWidget {
  @override
  _HistorijaNarudzbiScreenState createState() =>
      _HistorijaNarudzbiScreenState();
}

class _HistorijaNarudzbiScreenState extends State<HistorijaNarudzbiScreen>
    with SingleTickerProviderStateMixin {
  late NarudzbaProvider narudzbaProvider;

  //SearchResult<Narudzba>? narudzbaResult;

  List<Narudzba> narudzbaList = [];
  Map<String, dynamic> searchRequest = {};

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

    narudzbaProvider = context.read<NarudzbaProvider>();
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
        _tabController.index == 0 ? 'zavrsena' : 'ponistena';

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
            _tabController.index == 0 ? 'zavrsena' : 'ponistena';

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(0),
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: "Završene"),
                  Tab(text: "Otkazane"),
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
                    "Historija narudžbi",
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
                children: [_buildZavrsene(), _buildOtkazane()],
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

  Widget _buildZavrsene() {
    if (narudzbaList == null) {
      return Center(child: CircularProgressIndicator());
    }
    if (narudzbaList
        .where((element) =>
            element.stateMachine == "zavrsena" &&
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
              "Nemate završenih narudžbi.",
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
            width: double.infinity,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Color.fromARGB(97, 158, 158, 158),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Ukupno uplaćeno: ${formatNumber(izracunajUkupno(narudzbaList))} KM"
              "\n Broj završenih narudžbi: ${narudzbaList.where((e) => e.korisnikId == AuthProvider.korisnikId && e.stateMachine == "zavrsena").length}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          ...narudzbaList!
              // .where((element) =>
              //     element.stateMachine == "zavrsena" &&
              //     element.korisnikId == AuthProvider.korisnikId)
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
                  "Nema više završenih narudžbi za prikazati.",
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

  Widget _buildOtkazane() {
    if (narudzbaList == null) {
      return Center(child: CircularProgressIndicator());
    }
    if (narudzbaList!
        .where((element) =>
            element.stateMachine == "ponistena" &&
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
              "Nemate poništenih narudžbi.",
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
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Color.fromARGB(97, 158, 158, 158),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Broj otkazanih narudžbi: ${narudzbaList.where((e) => e.korisnikId == AuthProvider.korisnikId && e.stateMachine == "ponistena").length}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ...narudzbaList!
              // .where((element) =>
              //     element.stateMachine == "ponistena" &&
              //     element.korisnikId == AuthProvider.korisnikId)
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
                  "Nema više otkazanih narudžbi za prikazati.",
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

  izracunajUkupno(List<Narudzba> result) {
    dynamic ukupno = 0;
    for (var i = 0; i < result.length; i++) {
      if (result[i].stateMachine == "zavrsena" &&
          result[i].korisnikId == AuthProvider.korisnikId) {
        ukupno += result[i].ukupnaCijena;
      }
    }
    return ukupno;
  }
}
