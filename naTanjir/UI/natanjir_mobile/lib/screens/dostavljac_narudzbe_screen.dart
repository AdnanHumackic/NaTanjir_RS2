import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:natanjir_mobile/models/narudzba.dart';
import 'package:natanjir_mobile/models/search_result.dart';
import 'package:natanjir_mobile/models/stavke_narudzbe.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/narudzba_provider.dart';
import 'package:natanjir_mobile/providers/stavke_narudzbe_provider.dart';
import 'package:natanjir_mobile/providers/utils.dart';
import 'package:natanjir_mobile/screens/detalji_narudzbe_screen.dart';
import 'package:natanjir_mobile/screens/korisnik_profile_screen.dart';
import 'package:provider/provider.dart';

class DostavljacNarudzbeScreen extends StatefulWidget {
  DostavljacNarudzbeScreen({super.key});
  @override
  _DostavljacNarudzbeScreenState createState() =>
      _DostavljacNarudzbeScreenState();
}

class _DostavljacNarudzbeScreenState extends State<DostavljacNarudzbeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late NarudzbaProvider narudzbaProvider;
  late StavkeNarudzbeProvider stavkeNarudzbeProvider;
  List<Narudzba> narudzbaList = [];
  SearchResult<StavkeNarudzbe>? stavkeNarudzbeResult;
  int page = 1;
  final int limit = 20;
  int total = 0;
  bool isFirstLoadRunning = false;
  bool hasNextPage = true;
  bool showbtn = false;
  bool isLoadMoreRunning = false;

  late ScrollController scrollController = ScrollController();
  Map<String, dynamic> searchRequest = {};
  @override
  void dispose() {
    scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    narudzbaProvider = context.read<NarudzbaProvider>();
    stavkeNarudzbeProvider = context.read<StavkeNarudzbeProvider>();
    _tabController = TabController(length: 2, vsync: this);
    narudzbaProvider = context.read<NarudzbaProvider>();
    scrollController = ScrollController();
    _firstLoad();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _brojNarudzbeController.clear();
        _brojNarudzbeController.text = '';
        searchRequest['brojNarudzbe'] = null;
        showbtn = false;
        _firstLoad();
        setState(() {});
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
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          _loadMore();
        }
      }
    });

    _initForm();
  }

  Future _initForm() async {
    stavkeNarudzbeResult = await stavkeNarudzbeProvider.get(filter: {
      'isProizvodIncluded': true,
    });
    if (mounted) {
      setState(() {});
    }
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
        _tabController.index == 0 ? ['uToku', 'preuzeta'] : ['kreirana'];
    searchRequest['restoranId'] = AuthProvider.restoranId;
    if (_tabController.index == 0) {
      searchRequest['dostavljacId'] = AuthProvider.korisnikId;
    } else {
      searchRequest['dostavljacId'] = null;
    }

    var narudzbaResult = await narudzbaProvider.get(
      filter: searchRequest,
      page: page,
      pageSize: 10,
      orderBy: 'DatumKreiranja',
      sortDirection: 'asc',
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
            _tabController.index == 0 ? ['uToku', 'preuzeta'] : ['kreirana'];
        searchRequest['restoranId'] = AuthProvider.restoranId;
        if (_tabController.index == 0) {
          searchRequest['dostavljacId'] = AuthProvider.korisnikId;
        } else {
          searchRequest['dostavljacId'] = null;
        }

        var narudzbaResult = await narudzbaProvider.get(
          filter: searchRequest,
          page: page,
          pageSize: 10,
          orderBy: 'DatumKreiranja',
          sortDirection: 'asc',
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            _buildHeader(),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: "Moje narudžbe"),
                Tab(text: "Nepreuzete narudžbe"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    child: _buildMojeNarudze(),
                  ),
                  SingleChildScrollView(
                    controller: scrollController,
                    child: _buildNepreuzeteNarudze(),
                  ),
                ],
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KorisnikProfileScreen()),
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
      ),
    );
  }

  TextEditingController _brojNarudzbeController = TextEditingController();
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(0),
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
              controller: _brojNarudzbeController,
              onChanged: (value) {
                searchRequest['brojNarudzbe'] = _brojNarudzbeController.text;
                _loadFiltered();
                setState(() {});
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: "Broj narudžbe",
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
        ],
      ),
    );
  }

  void _loadFiltered() async {
    setState(() {
      isLoadMoreRunning = true;
    });
    searchRequest['stateMachine'] = ['uToku', 'preuzeta'];
    searchRequest['restoranId'] = AuthProvider.restoranId;
    searchRequest['dostavljacId'] = AuthProvider.korisnikId;
    var proizvodResult = await narudzbaProvider.get(
      filter: searchRequest,
      pageSize: limit,
      page: 1,
    );

    if (proizvodResult != null && proizvodResult.result.isNotEmpty) {
      narudzbaList = proizvodResult.result;
    } else {
      narudzbaList = [];
    }

    setState(() {
      isLoadMoreRunning = false;
    });
  }

  Widget _buildMojeNarudze() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          _buildSearch(),
          SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Color.fromARGB(97, 158, 158, 158),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Broj aktivnih narudžbi: ${narudzbaList.where((e) => e.stateMachine == "preuzeta").length}",
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DetaljiNarudzbeScreen(narudzba: e),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Narudžba #${e.brojNarudzbe}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Datum kreiranja ${formatDateTime(e.datumKreiranja.toString())}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${stavkeNarudzbeResult?.result?.where((stavka) => stavka.narudzbaId == e.narudzbaId).map((stavka) => "${stavka.proizvod?.naziv ?? 'Nepoznato'} x ${stavka.kolicina}").join(", ") ?? 'Nema stavki'}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Divider(
                          color: Color.fromARGB(255, 0, 83, 86),
                          thickness: 1,
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "${stavkeNarudzbeResult?.result?.where((stavka) => stavka.narudzbaId == e?.narudzbaId).length ?? 0} stavke/i",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              flex: 2,
                              child: Text(
                                "Potrebno platiti: ${formatNumber(e.ukupnaCijena)} KM",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 0, 83, 86)),
                            onPressed: () async {
                              await narudzbaProvider.uToku(e.narudzbaId!);
                              await ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Color.fromARGB(255, 0, 83, 86),
                                  duration: Duration(seconds: 1),
                                  content: Center(
                                    child: Text(
                                        "Narudžba #${e!.brojNarudzbe} je u toku."),
                                  ),
                                ),
                              );
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetaljiNarudzbeScreen(narudzba: e),
                                ),
                              )
                                  .then((value) {
                                if (value == true) {
                                  _firstLoad();
                                  setState(() {});
                                }
                              });
                            },
                            child: Text("Na putu",
                                style: TextStyle(color: Colors.white)),
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
              width: 350,
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
                  "Nema više aktivnih narudžbi za prikazati.",
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

  Widget _buildNepreuzeteNarudze() {
    return Padding(
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
              "Broj nepreuzetih narudžbi: ${narudzbaList.where((e) => e.stateMachine == "kreirana").length}",
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DetaljiNarudzbeScreen(narudzba: e),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Narudžba #${e.brojNarudzbe}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        if (e.stateMachine == "kreirana")
                          Text(
                            "Narudžba #${e.brojNarudzbe} još uvijek nije preuzeta od strane dostavljača.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        Text(
                          "Datum kreiranja ${formatDateTime(e.datumKreiranja.toString())}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${stavkeNarudzbeResult?.result?.where((stavka) => stavka.narudzbaId == e.narudzbaId).map((stavka) => "${stavka.proizvod?.naziv ?? 'Nepoznato'} x ${stavka.kolicina}").join(", ") ?? 'Nema stavki'}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Divider(
                          color: Color.fromARGB(255, 0, 83, 86),
                          thickness: 1,
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "${stavkeNarudzbeResult?.result?.where((stavka) => stavka.narudzbaId == e?.narudzbaId).length ?? 0} stavke/i",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              flex: 2,
                              child: Text(
                                "Potrebno platiti: ${formatNumber(e.ukupnaCijena)} KM",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 0, 83, 86)),
                            onPressed: () async {
                              await narudzbaProvider.preuzmi(
                                  e.narudzbaId!, AuthProvider.korisnikId!);
                              await ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Color.fromARGB(255, 0, 83, 86),
                                  duration: Duration(seconds: 1),
                                  content: Center(
                                    child: Text(
                                        "Narudžba #${e!.brojNarudzbe} je u preuzeta."),
                                  ),
                                ),
                              );
                              _firstLoad();
                              setState(() {});
                            },
                            child: Text("Preuzmi",
                                style: TextStyle(color: Colors.white)),
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
              width: 350,
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
                  "Nema više nepreuzetih narudžbi za prikazati.",
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
