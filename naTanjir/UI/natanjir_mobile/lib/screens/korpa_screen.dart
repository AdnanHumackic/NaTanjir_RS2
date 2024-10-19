import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/cart_provider.dart';
import 'package:natanjir_mobile/providers/utils.dart';
import 'package:natanjir_mobile/screens/kreiranje_narudzbe_screen.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class KorpaScreen extends StatefulWidget {
  KorpaScreen({super.key});

  @override
  State<KorpaScreen> createState() => _KorpaScreenState();
}

class _KorpaScreenState extends State<KorpaScreen> {
  final CartProvider cartProvider = CartProvider(AuthProvider.korisnikId!);
  Map<String, dynamic> cartItems = {};
  late ScrollController scrollController = ScrollController();
  bool showbtn = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      double showOffset = 10.0;
      if (scrollController.offset > showOffset) {
        showbtn = true;
      } else {
        showbtn = false;
      }
      setState(() {});

      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {}
    });
    _loadCart();
  }

  Future<void> _loadCart() async {
    cartItems = await cartProvider.getCart();
    setState(() {});
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
                    "Vaša korpa",
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
              controller: scrollController,
              padding: const EdgeInsets.all(10),
              child: _buildPage(),
            ),
          ),
          _buildFooter(),
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
    );
  }

  Widget _buildPage() {
    if (cartItems.isEmpty) {
      return Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 15),
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
              "Vaša korpa je prazna.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: cartItems.entries.map((entry) {
        final productDetails = entry.value;
        return Container(
          width: double.infinity,
          height: 110,
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
                    await cartProvider
                        .deleteProductFromCart(productDetails['id']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Color.fromARGB(255, 0, 83, 86),
                        duration: Duration(milliseconds: 500),
                        content: Center(
                          child: Text("Proizvod je obrisan iz korpe."),
                        ),
                      ),
                    );
                    cartItems = await cartProvider.getCart();
                    setState(() {});
                  },
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: 'Obriši',
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
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: productDetails['slika'] == null
                              ? imageFromString(productDetails['slika'])
                              : Image.asset(
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
                          productDetails['naziv'] ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${formatNumber(productDetails['cijena'])} KM',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 108, 108, 108),
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: InkWell(
                                onTap: () async {
                                  productDetails['kolicina'] =
                                      (productDetails['kolicina'] - 1)
                                          .clamp(1, double.infinity);
                                  await cartProvider.updateCart(
                                      productDetails['id'],
                                      productDetails['kolicina']);

                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.remove_circle,
                                  size: 35,
                                  color: Color.fromARGB(150, 158, 158, 158),
                                ),
                              ),
                            ),
                            Text(
                              '${productDetails['kolicina']}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 108, 108, 108),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                await cartProvider.updateCart(
                                    productDetails['id'],
                                    productDetails['kolicina'] + 1);
                                productDetails['kolicina']++;
                                setState(() {});
                              },
                              child: Icon(
                                Icons.add_circle_outlined,
                                size: 35,
                                color: Color.fromARGB(255, 0, 83, 86),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
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
                      "${izracunajUkupnuCijenu()} KM",
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
              SizedBox(width: 15),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    if (cartItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(milliseconds: 500),
                          content: Center(child: Text("Korpa je prazna.")),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => KreiranjeNarudzbeScreen(
                              odabraniProizvodi: cartItems.entries.toList(),
                              ukupnaCijena: izracunajUkupnuCijenu())));
                    }
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
                        "Naruči",
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

  dynamic izracunajUkupnuCijenu() {
    var totalPrice = 0.0;
    for (var item in cartItems.entries) {
      totalPrice += item.value['cijena'] * item.value['kolicina'];
    }
    return formatNumber(totalPrice);
  }
}
