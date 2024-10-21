import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/korisnici.dart';
import 'package:natanjir_desktop/models/narudzba.dart';
import 'package:natanjir_desktop/models/restoran.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/providers/korisnici_provider.dart';
import 'package:natanjir_desktop/providers/narudzba_provider.dart';
import 'package:natanjir_desktop/providers/restoran_provider.dart';
import 'package:natanjir_desktop/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late KorisniciProvider korisniciProvider;
  late RestoranProvider restoranProvider;
  late NarudzbaProvider narudzbaProvider;

  SearchResult<Korisnici>? korisniciResult;
  SearchResult<Restoran>? restoranResult;
  SearchResult<Narudzba>? narudzbaResult;

  void initState() {
    super.initState();
    korisniciProvider = context.read<KorisniciProvider>();
    restoranProvider = context.read<RestoranProvider>();
    narudzbaProvider = context.read<NarudzbaProvider>();

    _initForm();
  }

  Future _initForm() async {
    restoranResult = await restoranProvider.get();
    korisniciResult = await korisniciProvider.get();
    narudzbaResult = await narudzbaProvider.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Dashboard",
      Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dashboardBg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [_buildPage(), _buildStats()],
          ),
        ),
      ),
    );
  }

  Widget _buildPage() {
    var otkazane = (narudzbaResult?.result ?? [])
        .where((e) => e.stateMachine == "ponistena")
        .length;
    var ukupno = (narudzbaResult?.result ?? []).length;
    var stopaOtkazivanja = ukupno > 0 ? (otkazane / ukupno) * 100 : 0;
    return Container(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  width: 250,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 83, 86),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('assets/images/dashboardImg1.png'),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 60.0, right: 10.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          children: [
                            TextSpan(text: "Broj korisnika\n aplikacije: "),
                            TextSpan(
                              text: "${korisniciResult?.count ?? 0}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  width: 250,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 83, 86),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('assets/images/dashboardImg2.png'),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 60.0, right: 10.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          children: [
                            TextSpan(text: "Broj restorana\n korisnika: "),
                            TextSpan(
                              text: "${restoranResult?.count ?? 0}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  width: 250,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 83, 86),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('assets/images/dashboardImg3.png'),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 60.0, right: 10.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          children: [
                            TextSpan(text: "Stopa otkazivanja\n narudžbi: "),
                            TextSpan(
                              text: "${formatNumber(stopaOtkazivanja)} %",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  width: 250,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 83, 86),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('assets/images/dashboardImg4.png'),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 60.0, right: 10.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          children: [
                            TextSpan(text: "Ukupan broj\n narudžbi: "),
                            TextSpan(
                              text: "${narudzbaResult?.count ?? 0}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    if (narudzbaResult == null || narudzbaResult!.result.isEmpty) {
      return Center(
          child: Text(
        'Trenutno nema podataka za prikazati',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ));
    }

    List<Narudzba> narudzbeList = narudzbaResult!.result
        .where((element) => element.stateMachine != "ponistena")
        .toList();

    List<int> narudzbePoMjesecima = List.filled(12, 0);

    for (var narudzba in narudzbeList) {
      DateTime date = DateTime.parse(narudzba.datumKreiranja!);
      int month = date.month - 1;
      narudzbePoMjesecima[month]++;
    }
    List<String> mjeseci = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    List<FlSpot> spots = List.generate(
      12,
      (index) =>
          FlSpot(index.toDouble(), narudzbePoMjesecima[index].toDouble()),
    );

    return Padding(
      padding: EdgeInsets.all(15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Color.fromARGB(255, 0, 83, 86),
          width: double.infinity,
          height: 600,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Broj narudžbi po mjesecima',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: (narudzbePoMjesecima
                                      .reduce((a, b) => a > b ? a : b) ~/
                                  5 +
                              1) *
                          5,
                      lineBarsData: [
                        LineChartBarData(
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.orange,
                              Colors.red,
                            ],
                          ),
                          aboveBarData: BarAreaData(
                              show: true, color: Colors.green.withOpacity(0.4)),
                          barWidth: 4,
                          isCurved: true,
                          show: true,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.red.withOpacity(0.4),
                          ),
                          dotData: FlDotData(
                            show: true,
                          ),
                          spots: spots,
                          color: Colors.red,
                        ),
                      ],
                      titlesData: FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(
                          axisNameWidget: Text(
                            "Broj narudžbi",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          axisNameSize: 80,
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 5,
                            getTitlesWidget: (value, meta) {
                              if (value % 5 == 0) {
                                return Text(
                                  "${value.toInt()}",
                                  style: TextStyle(color: Colors.white),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          axisNameWidget: Text(
                            "Mjesec",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          axisNameSize: 80,
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              if (value >= 0 && value < mjeseci.length) {
                                return Text(
                                  mjeseci[value.toInt()],
                                  style: TextStyle(color: Colors.white),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          axisNameWidget: Text(""),
                        ),
                        topTitles: AxisTitles(
                          axisNameWidget: Text(""),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
