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

class _NarudzbeListScreenState extends State<NarudzbeListScreen> {
  late NarudzbaProvider narudzbaProvider;

  SearchResult<Narudzba>? narudzbaResult;
  Map<String, dynamic> searchRequest = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    searchRequest = {
      'korisnikId': AuthProvider.korisnikId!,
      'stateMachine': "kreirana",
      'isStavkeNarudzbeIncluded': true,
    };
    narudzbaProvider = context.read<NarudzbaProvider>();
    _initForm();
  }

  Future _initForm() async {
    narudzbaResult = await narudzbaProvider.get(
        filter: searchRequest,
        orderBy: 'DatumKreiranja',
        sortDirection: 'desc');
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 5),
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
                    "Vaše aktivne narudžbe",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: _buildPage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage() {
    if (narudzbaResult == null) {
      return Center(child: CircularProgressIndicator());
    }
    if (narudzbaResult!.result.isEmpty) {
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
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: narudzbaResult!.result
            .map(
              (e) => InkWell(
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          DetaljiNarudzbeScreen(narudzba: e)));
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
      ),
    );
  }
}
