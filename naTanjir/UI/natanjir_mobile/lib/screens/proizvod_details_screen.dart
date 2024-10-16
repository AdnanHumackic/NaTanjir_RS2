import 'package:flutter/material.dart';
import 'package:natanjir_mobile/models/proizvod.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/base_provider.dart';
import 'package:natanjir_mobile/providers/cart_provider.dart';
import 'package:natanjir_mobile/providers/utils.dart';

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
  final CartProvider cartProvider = CartProvider(AuthProvider.korisnikId!);

  var quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
          Container(
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
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Expanded(
                          //   child: Text(
                          //     "Dio za ocj proizv",
                          //     style: TextStyle(
                          //       fontSize: 15,
                          //       color: Color.fromARGB(255, 108, 108, 108),
                          //       fontWeight: FontWeight.w600,
                          //       overflow: TextOverflow.ellipsis,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(width: 8.0),
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                quantity != 1 ? quantity-- : quantity;

                                setState(() {});
                              },
                              child: Icon(
                                Icons.remove_circle,
                                size: 35,
                                color: Color.fromARGB(255, 0, 83, 86),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Flexible(
                            flex: 3,
                            child: Text(
                              quantity.toString(),
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                quantity++;
                                setState(() {});
                              },
                              child: Icon(
                                Icons.add_circle,
                                size: 35,
                                color: Color.fromARGB(255, 0, 83, 86),
                              ),
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
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    height: 50,
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
                    child: InkWell(
                      onTap: () async {
                        try {
                          await cartProvider.addToCart(
                              widget.odabraniProizvod as Proizvod, quantity);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color.fromARGB(255, 0, 83, 86),
                              duration: Duration(milliseconds: 500),
                              content: Center(
                                child: Text("Proizvod je dodan u korpu."),
                              ),
                            ),
                          );
                        } on Exception catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 1),
                              content: Center(
                                child: Text(e.toString()),
                              ),
                            ),
                          );
                        }
                        setState(() {});
                      },
                      child: Center(
                        child: Text(
                          "Dodaj u korpu",
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
              ),
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
