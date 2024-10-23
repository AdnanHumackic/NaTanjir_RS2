import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/ocjena_proizvod.dart';
import 'package:natanjir_desktop/models/proizvod.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:natanjir_desktop/providers/base_provider.dart';
import 'package:natanjir_desktop/providers/ocjena_proizvod_provider.dart';
import 'package:natanjir_desktop/providers/utils.dart';
import 'package:provider/provider.dart';

class ProizvodDetailsScreen extends StatefulWidget {
  final Proizvod? odabraniProizvod;
  final dynamic avgOcjena;

  ProizvodDetailsScreen(
      {Key? key, required this.odabraniProizvod, required this.avgOcjena})
      : super(key: key);

  @override
  State<ProizvodDetailsScreen> createState() => _ProizvodDetailsScreenState();
}

class _ProizvodDetailsScreenState extends State<ProizvodDetailsScreen> {
  late OcjenaProizvodProvider ocjenaProizvodProvider;

  SearchResult<OcjenaProizvod>? ocjenaProizvodResult;

  var quantity = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    ocjenaProizvodProvider = context.read<OcjenaProizvodProvider>();
    _initForm();
  }

  Future _initForm() async {
    ocjenaProizvodResult = await ocjenaProizvodProvider.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Detalji proizvoda",
      Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [_buildPage(), _buildRecommended()],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 370,
            height: 320,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: widget.odabraniProizvod!.slika != null &&
                        widget.odabraniProizvod!.slika!.isNotEmpty
                    ? imageFromString(widget.odabraniProizvod!.slika!)
                    : Image.asset(
                        "assets/images/emptyProductImage.png",
                        fit: BoxFit.fill,
                      ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 15),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.odabraniProizvod!.naziv!,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.odabraniProizvod!.opis!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 108, 108, 108),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(
            color: Color.fromARGB(255, 0, 83, 86),
            height: 1.0,
            thickness: 2,
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 83, 86),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "${formatNumber(widget.odabraniProizvod!.cijena)} KM",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommended() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
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
                  "Uz ${widget.odabraniProizvod!.naziv} kupci naručuju",
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
}
