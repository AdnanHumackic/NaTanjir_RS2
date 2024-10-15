import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:natanjir_mobile/layouts/master_screen.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/cart_provider.dart';
import 'package:natanjir_mobile/providers/narudzba_provider.dart';
import 'package:natanjir_mobile/screens/korpa_screen.dart';
import 'package:natanjir_mobile/screens/restoran_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class KreiranjeNarudzbeScreen extends StatefulWidget {
  final List<dynamic> odabraniProizvodi;
  final dynamic ukupnaCijena;
  String? secret;
  String? public;
  String? sandBoxMode;

  KreiranjeNarudzbeScreen(
      {super.key,
      required this.odabraniProizvodi,
      required this.ukupnaCijena}) {
    secret = const String.fromEnvironment("_paypalSecret", defaultValue: "");
    public = const String.fromEnvironment("_paypalPublic", defaultValue: "");
    sandBoxMode =
        const String.fromEnvironment("_sandBoxMode", defaultValue: "true");
  }

  @override
  State<KreiranjeNarudzbeScreen> createState() =>
      _KreiranjeNarudzbeScreenState();
}

class _KreiranjeNarudzbeScreenState extends State<KreiranjeNarudzbeScreen> {
  late NarudzbaProvider narudzbaProvider;
  final CartProvider cartProvider = CartProvider(AuthProvider.korisnikId!);

  @override
  void initState() {
    super.initState();
    narudzbaProvider = context.read<NarudzbaProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: _buildPage(),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildPage() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                "Pregled narudžbe",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderDetail("Narudžba:",
                    "${widget.ukupnaCijena?.toString() ?? '0'} KM"),
                SizedBox(height: 10),
                _buildOrderDetail(
                    "Broj artikala:", "${widget.odabraniProizvodi.length}"),
                Divider(),
                _buildOrderDetail(
                    "Ukupno:", "${(widget.ukupnaCijena ?? 0).toString()} KM"),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Procijenjeno vrijeme dostave: 15 - 30 min',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOrderDetail(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ),
        Flexible(
          flex: 1,
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ),
      ],
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
                flex: 2,
                child: Container(
                  height: 45,
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
                      "Ukupno: ${widget.ukupnaCijena?.toString() ?? '0'} KM",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () async {
                    await makePayment();
                  },
                  child: Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 60, 47, 47),
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
                        "Kreiraj",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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

  Future makePayment() async {
    var secret = dotenv.env['_paypalSecret'];
    var public = dotenv.env['_paypalPublic'];

    var valueSecret =
        (widget.secret == "" || widget.secret == null) ? secret : widget.secret;
    var valuePublic =
        (widget.public == "" || widget.public == null) ? public : widget.public;

    if ((valueSecret?.isEmpty ?? true) || (valuePublic?.isEmpty ?? true)) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Greška",
          text: "Greška sa plaćanjem.");
      return;
    }

    var formattedTotal = widget.ukupnaCijena.replaceAll(',', '.');

    var total = double.parse(formattedTotal).toStringAsFixed(2);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => PaypalCheckoutView(
              sandboxMode: widget.sandBoxMode == "true"
                  ? true
                  : widget.sandBoxMode == "false"
                      ? false
                      : true,
              clientId: valuePublic,
              secretKey: valueSecret,
              transactions: [
                {
                  "amount": {
                    "total": total,
                    "currency": "USD",
                    "details": {
                      "subtotal": total,
                      "shipping": '0',
                      "shipping_discount": 0
                    }
                  },
                  "description": "Narudžba ce se dodati.",
                  "item_list": {
                    "items": widget.odabraniProizvodi.map((entry) {
                      final proizvod = entry.value;
                      var cijena = (proizvod['cijena']).toStringAsFixed(2);
                      return {
                        "name": proizvod['naziv'],
                        "quantity": proizvod['kolicina'].toString(),
                        "price": cijena,
                        "currency": "USD",
                      };
                    }).toList(),
                  }
                }
              ],
              note: "Kontaktirajte ukoliko imate poteškoća.",
              onSuccess: (Map params) async {
                try {
                  List<Map<String, dynamic>> stavkeNarudzbe =
                      widget.odabraniProizvodi.map((entry) {
                    final proizvod = entry.value;
                    return {
                      "kolicina": proizvod['kolicina'],
                      "cijena": proizvod['cijena'],
                      "proizvodId": proizvod['id'],
                      "restoranId": proizvod['restoranId'],
                    };
                  }).toList();

                  await narudzbaProvider.insert({
                    "brojNarudzbe": generateRandomNumber(),
                    "ukupnaCijena": total,
                    "korisnikId": AuthProvider.korisnikId,
                    "datumKreiranja": DateTime.now().toIso8601String(),
                    "stavkeNarudzbe": stavkeNarudzbe,
                  });
                  widget.odabraniProizvodi.clear();
                  stavkeNarudzbe.clear();
                  await cartProvider.clearCart();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MasterScreen()),
                  );
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    title: "Uspješno kreirana narudžba.",
                  );
                } on Exception catch (e) {}
              },
              onError: (error) {
                print("onSuccess: $error");
                ("onError: $error");
                Navigator.pop(context);
              },
              onCancel: () {
                print('cancelled:');
                Navigator.pop(context);
              },
            )),
      ),
    );
  }

  int? generateRandomNumber() {
    Random random = new Random();
    return random.nextInt(10000);
  }
}
