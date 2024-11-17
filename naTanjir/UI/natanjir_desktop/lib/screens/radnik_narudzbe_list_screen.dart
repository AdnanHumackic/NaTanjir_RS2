import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/narudzba.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/stavke_narudzbe.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:natanjir_desktop/providers/narudzba_provider.dart';
import 'package:natanjir_desktop/providers/signalr_provider.dart';
import 'package:natanjir_desktop/providers/stavke_narudzbe_provider.dart';
import 'package:natanjir_desktop/providers/utils.dart';
import 'package:natanjir_desktop/screens/detalji_narudzbe_screen.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class RadnikNarudzbeListScreen extends StatefulWidget {
  RadnikNarudzbeListScreen({Key? key}) : super(key: key);

  @override
  _RadnikNarudzbeListScreenState createState() =>
      _RadnikNarudzbeListScreenState();
}

class _RadnikNarudzbeListScreenState extends State<RadnikNarudzbeListScreen>
    with SingleTickerProviderStateMixin {
  late NarudzbaProvider narudzbaProvider;
  late StavkeNarudzbeProvider stavkeNarudzbeProvider;

  List<Narudzba> narudzbaList = [];
  SearchResult<StavkeNarudzbe>? stavkeNarudzbeResult;
  late TabController _tabController;
  final SignalRProvider _signalRProvider = SignalRProvider();

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
    _signalRProvider.onNotificationReceived = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    narudzbaProvider = context.read<NarudzbaProvider>();
    stavkeNarudzbeProvider = context.read<StavkeNarudzbeProvider>();
    _tabController = TabController(length: 2, vsync: this);
    narudzbaProvider = context.read<NarudzbaProvider>();

    _firstLoad();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _brojNarudzbeController.clear();
        _brojNarudzbeController.text = '';
        searchRequest['brojNarudzbe'] = null;
        datumGTE = null;
        searchRequest['datumKreiranjaGTE'] = null;
        showbtn = false;
        _firstLoad();
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
    _signalRProvider?.onNotificationReceived = (message) {
      if (message.isNotEmpty) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          title: "Obavijest",
          text: message,
          onConfirmBtnTap: () async {
            Navigator.of(context).pop();
            await _firstLoad();
            setState(() {});
          },
        );
        setState(() {});
      }
    };

    _initForm();
  }

  Future _initForm() async {
    stavkeNarudzbeResult = await stavkeNarudzbeProvider.get(filter: {
      'isProizvodIncluded': true,
    });
    setState(() {});
  }

  Future<void> _firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
      narudzbaList = [];
      page = 1;
      hasNextPage = true;
      isLoadMoreRunning = false;
    });
    searchRequest['stateMachine'] = _tabController.index == 0
        ? ['kreirana', 'preuzeta']
        : ['zavrsena', 'ponistena'];

    searchRequest['restoranId'] = AuthProvider.restoranId;

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
        searchRequest['stateMachine'] = _tabController.index == 0
            ? ['kreirana', 'preuzeta']
            : ['zavrsena', 'ponistena'];

        searchRequest['restoranId'] = AuthProvider.restoranId;

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

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Upravljanje restoranima",
      Scaffold(
        body: Padding(
          padding: EdgeInsets.all(25),
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              body: Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(0),
                      child: TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: "Narudžbe"),
                          Tab(text: "Historija narudžbi"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildNarudzbe(),
                          _buildHistorijaNarudzbi(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
      ),
    );
  }

  TextEditingController _brojNarudzbeController = TextEditingController();
  Widget _buildSearchNarudzbe() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: SizedBox(
        width: double.infinity,
        child: TextField(
          controller: _brojNarudzbeController,
          onChanged: (value) async {
            setState(() {
              searchRequest['brojNarudzbe'] = _brojNarudzbeController.text;
              _loadFiltered();
            });
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            labelText: 'Broj narudžbe',
            hintText: 'Broj narudžbe',
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 108, 108, 108),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildNarudzbe() {
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          _buildSearchNarudzbe(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Color.fromARGB(97, 158, 158, 158),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Broj aktivnih narudžbi: ${narudzbaList.where((e) => e.stateMachine == "kreirana").length}",
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
                        if (e.stateMachine == "preuzeta")
                          Text(
                            "Narudžba #${e.brojNarudzbe} je preuzeta od strane dostavljača.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        Text(
                          "Datum kreiranja ${formatDate(e.datumKreiranja.toString())}",
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

  void _loadFiltered() async {
    setState(() {
      isLoadMoreRunning = true;
    });
    searchRequest['stateMachine'] = ['kreirana', 'preuzeta'];
    searchRequest['restoranId'] = AuthProvider.restoranId;

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

  Widget _buildHistorijaNarudzbi() {
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          _buildSearchHistorije(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Color.fromARGB(97, 158, 158, 158),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Broj završenih narudžbi: ${narudzbaList.where((e) => e.stateMachine == "zavrsena").length}\n"
              "Broj otkazanih narudžbi: ${narudzbaList.where((e) => e.stateMachine == "ponistena").length}",
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
                          "Status narudžbe: ${e.stateMachine}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          "Datum kreiranja ${formatDate(e.datumKreiranja.toString())}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${stavkeNarudzbeResult?.result?.where((stavka) => stavka.narudzbaId == e?.narudzbaId).map((stavka) {
                                final proizvodNaziv = stavka.proizvod?.naziv ??
                                    "Nepoznat proizvod";
                                return "$proizvodNaziv x ${stavka.kolicina}";
                              }).join(", ") ?? "Nema stavki"}",
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

  DateTime? datumGTE;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: datumGTE ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        datumGTE = picked;
      });
      _loadFilteredHistorija();
    }
  }

  Widget _buildSearchHistorije() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: datumGTE == null
                              ? "Izaberite datum"
                              : "Izabrani datum: ${formatDate(datumGTE.toString())}",
                          prefixIcon: Icon(Icons.calendar_today),
                          labelText: 'Narudžbe poslije',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 108, 108, 108),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9),
                width: 250,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 0, 83, 86),
                ),
                child: InkWell(
                  onTap: () async {
                    datumGTE = null;
                    searchRequest['datumKreiranjaGTE'] = null;
                    _firstLoad();
                    setState(() {});
                  },
                  child: Center(
                    child: Text(
                      "Očisti filter",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _loadFilteredHistorija() async {
    setState(() {
      isLoadMoreRunning = true;
    });

    searchRequest['stateMachine'] = ['zavrsena', 'ponistena'];
    searchRequest['restoranId'] = AuthProvider.restoranId;

    DateTime datumGte = datumGTE ?? DateTime.now();
    searchRequest['datumKreiranjaGTE'] =
        datumGte.toIso8601String().split('T')[0];

    print(searchRequest['datumKreiranjaGTE']);

    setState(() {});
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
}
