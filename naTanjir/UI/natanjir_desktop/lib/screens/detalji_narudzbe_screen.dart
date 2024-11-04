import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/korisnici.dart';
import 'package:natanjir_desktop/models/narudzba.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/stavke_narudzbe.dart';
import 'package:natanjir_desktop/providers/korisnici_provider.dart';
import 'package:natanjir_desktop/providers/stavke_narudzbe_provider.dart';
import 'package:natanjir_desktop/providers/utils.dart';
import 'package:provider/provider.dart';

class DetaljiNarudzbeScreen extends StatefulWidget {
  final Narudzba? narudzba;

  const DetaljiNarudzbeScreen({super.key, required this.narudzba});

  @override
  State<DetaljiNarudzbeScreen> createState() => _DetaljiNarudzbeScreenState();
}

class _DetaljiNarudzbeScreenState extends State<DetaljiNarudzbeScreen> {
  late StavkeNarudzbeProvider stavkeNarudzbeProvider;
  late KorisniciProvider korisniciProvider;

  SearchResult<StavkeNarudzbe>? stavkeNarudzbeResult;
  SearchResult<Korisnici>? korisnikResult;
  Map<String, dynamic> searchRequest = {};

  @override
  void initState() {
    super.initState();
    stavkeNarudzbeProvider = context.read<StavkeNarudzbeProvider>();
    korisniciProvider = context.read<KorisniciProvider>();
    _initForm();
  }

  Future _initForm() async {
    searchRequest = {
      'narudzbaId': widget.narudzba!.narudzbaId,
      'isProizvodIncluded': true,
      'isRestoranIncluded': true,
      'isKorisnikIncluded': true
    };
    stavkeNarudzbeResult = await stavkeNarudzbeProvider.get(
      filter: searchRequest,
    );
    korisnikResult = await korisniciProvider.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Detalji narudzbe",
      Scaffold(
        body: Column(
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
                      "Narudžba broj: #${widget.narudzba!.brojNarudzbe}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: _buildPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    if (stavkeNarudzbeResult == null || stavkeNarudzbeResult!.result.isEmpty) {
      return SizedBox.shrink();
    }

    final stavkaNarudzbe = stavkeNarudzbeResult!.result.first;
    final restoran = stavkaNarudzbe.restoran;

    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
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
                  child: restoran != null &&
                          restoran!.slika != null &&
                          restoran!.slika!.isNotEmpty
                      ? imageFromString(restoran!.slika!)
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
                    restoran?.naziv ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    restoran?.lokacija ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage() {
    if (stavkeNarudzbeResult == null) {
      return Center(child: CircularProgressIndicator());
    }
    if (stavkeNarudzbeResult!.result.isEmpty) {
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
              ".",
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
        children: [
          Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Narudžba kreirana: ${formatDateTime(widget.narudzba!.datumKreiranja.toString())}",
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 108, 108, 108),
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Status narudžbe: ${widget.narudzba!.stateMachine}",
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 108, 108, 108),
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: korisnikResult!.result
                  .where((element) =>
                      element.korisnikId == widget.narudzba?.korisnikId)
                  .map((e) => Text(
                        "Narudžbu kreirao/la: ${e.ime} ${e.prezime}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 108, 108, 108),
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(thickness: 1, color: Colors.grey),
          ...stavkeNarudzbeResult!.result
              .map(
                (e) => Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${e.proizvod!.naziv} x${e.kolicina}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${formatNumber(e.cijena)} KM",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          Divider(thickness: 1, color: Colors.grey),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 83, 86),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ukupno:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Flexible(
                  child: Text(
                    "${formatNumber(widget.narudzba!.ukupnaCijena)} KM",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
