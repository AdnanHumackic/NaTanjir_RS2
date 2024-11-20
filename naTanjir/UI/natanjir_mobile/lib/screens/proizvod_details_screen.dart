import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:natanjir_mobile/models/ocjena_proizvod.dart';
import 'package:natanjir_mobile/models/proizvod.dart';
import 'package:natanjir_mobile/models/search_result.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/base_provider.dart';
import 'package:natanjir_mobile/providers/cart_provider.dart';
import 'package:natanjir_mobile/providers/ocjena_proizvod_provider.dart';
import 'package:natanjir_mobile/providers/product_provider.dart';
import 'package:natanjir_mobile/providers/utils.dart';
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
  late ProductProvider proizvodProvider;
  List<Proizvod> proizvodList = [];

  SearchResult<OcjenaProizvod>? ocjenaProizvodResult;

  final CartProvider? cartProvider = AuthProvider.korisnikId == null
      ? null
      : CartProvider(AuthProvider.korisnikId!);
  var quantity = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    ocjenaProizvodProvider = context.read<OcjenaProizvodProvider>();
    proizvodProvider = context.read<ProductProvider>();
    _initForm();
  }

  Future _initForm() async {
    ocjenaProizvodResult = await ocjenaProizvodProvider.get();
    var proizvodi = await proizvodProvider
        .getRecommendedProducts(widget.odabraniProizvod!.proizvodId!);
    proizvodList = proizvodi;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (AuthProvider.korisnikId != null) {
          return await _showDialog(context) ?? false;
        }
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
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
                          if (AuthProvider.korisnikId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 1),
                                content: Center(
                                  child: Text(
                                      "Morate biti prijavljeni da biste dodali proizvod u korpu."),
                                ),
                              ),
                            );
                            return;
                          }
                          await cartProvider!.addToCart(
                            widget.odabraniProizvod as Proizvod,
                            quantity,
                          );

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
            proizvodList.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Nema preporučenih proizvoda.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: proizvodList.map((proizvod) {
                        return Card(
                          surfaceTintColor: Colors.white,
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: double.infinity),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(10),
                              title: Text(
                                proizvod.naziv!,
                                style: TextStyle(fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${formatNumber(proizvod!.cijena)} KM',
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: proizvod!.slika != null &&
                                        proizvod!.slika!.isNotEmpty
                                    ? imageFromString(proizvod!.slika!)
                                    : Image.asset(
                                        "assets/images/emptyProductImage.png",
                                        fit: BoxFit.cover,
                                        width: 50,
                                        height: 50,
                                      ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.add_circle,
                                  size: 35,
                                  color: Color.fromARGB(255, 0, 83, 86),
                                ),
                                onPressed: () async {
                                  //dodati btn za vracanje nazad kad udjes kao neprijavljen
                                  try {
                                    if (AuthProvider.korisnikId == null) {
                                      await ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 1),
                                          content: Center(
                                            child: Text(
                                                "Morate biti prijavljeni da biste dodali proizvod u korpu."),
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    await cartProvider!.addToCart(
                                      proizvod,
                                      quantity,
                                    );

                                    await ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            Color.fromARGB(255, 0, 83, 86),
                                        duration: Duration(milliseconds: 500),
                                        content: Center(
                                          child: Text(
                                              "Proizvod je dodan u korpu."),
                                        ),
                                      ),
                                    );
                                  } on Exception catch (e) {
                                    await ScaffoldMessenger.of(context)
                                        .showSnackBar(
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
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDialog(BuildContext context) async {
    var ocjenaKorisnik;
    if (ocjenaProizvodResult != null) {
      try {
        ocjenaKorisnik = await ocjenaProizvodResult!.result.firstWhere(
          (e) =>
              e.korisnikId == AuthProvider.korisnikId &&
              e.ocjena != null &&
              e.proizvodId == widget.odabraniProizvod!.proizvodId,
        );
      } catch (e) {
        ocjenaKorisnik = null;
      }
    }

    double? vrijednost;
    return showDialog<bool>(
      context: context,
      builder: (context) {
        if (ocjenaKorisnik == null) {
          return AlertDialog(
            title: Text(
              'Niste ocijenili proizvod?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            content: RatingBar.builder(
              initialRating: 0,
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 50.0,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (value) {
                vrijednost = value;
              },
              unratedColor: Colors.grey[300],
              glow: false,
              glowColor: Colors.amber.withOpacity(0.5),
              ignoreGestures: false,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Nemoj ocjeniti'),
              ),
              TextButton(
                onPressed: () async {
                  if (vrijednost != null) {
                    DateTime datum = DateTime.now();
                    var dateNow = datum.toIso8601String().split('T')[0];
                    var request = {
                      'ocjena': vrijednost,
                      'proizvodId': widget.odabraniProizvod!.proizvodId,
                      'korisnikId': AuthProvider.korisnikId,
                      'datumKreiranja': dateNow,
                    };

                    try {
                      await ocjenaProizvodProvider.insert(request);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Color.fromARGB(255, 0, 83, 86),
                          duration: Duration(seconds: 1),
                          content: Text(
                            'Proizvod uspješno ocijenjen.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 1),
                          content: Text(
                            'Došlo je do greške prilikom spremanja ocjene.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  }
                  Navigator.of(context).pop(true);
                },
                child: Text('Ocjeni'),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(
              'Da li želite ažurirati ocjenu?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            content: RatingBar.builder(
              initialRating: ocjenaKorisnik.ocjena,
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 50.0,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (value) {
                vrijednost = value;
              },
              unratedColor: Colors.grey[300],
              glow: false,
              glowColor: Colors.amber.withOpacity(0.5),
              ignoreGestures: false,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Ne'),
              ),
              TextButton(
                onPressed: () async {
                  if (vrijednost != null) {
                    DateTime datum = DateTime.now();
                    var dateNow = datum.toIso8601String().split('T')[0];
                    var request = {
                      'ocjena': vrijednost,
                      'proizvodId': widget.odabraniProizvod!.proizvodId,
                      'korisnikId': AuthProvider.korisnikId,
                      'datumKreiranja': dateNow,
                    };
                    try {
                      var ocjId = await ocjenaProizvodResult!.result.firstWhere(
                        (e) =>
                            e.korisnikId == AuthProvider.korisnikId &&
                            e.proizvodId == widget.odabraniProizvod!.proizvodId,
                      );
                      await ocjenaProizvodProvider.update(
                          ocjId.ocjenaProizvodId!, request);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Color.fromARGB(255, 0, 83, 86),
                          duration: Duration(seconds: 1),
                          content: Text(
                            'Ocjena je uspješno ažurirana.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 1),
                          content: Text(
                            'Došlo je do greške prilikom ažuriranja ocjene.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  }
                  Navigator.of(context).pop(true);
                },
                child: Text('Ažuriraj ocjenu'),
              ),
            ],
          );
        }
      },
    );
  }
}
