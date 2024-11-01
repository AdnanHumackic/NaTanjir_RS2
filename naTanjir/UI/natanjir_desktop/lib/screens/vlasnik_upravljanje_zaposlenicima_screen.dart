import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/uloga.dart';
import 'package:natanjir_desktop/providers/korisnici_provider.dart';
import 'package:natanjir_desktop/providers/uloga_provider.dart';
import 'package:natanjir_desktop/screens/vlasnik_dodaj_radnika_screen.dart';
import 'package:provider/provider.dart';

class VlasnikUpravljanjeZaposlenicimaScreen extends StatefulWidget {
  const VlasnikUpravljanjeZaposlenicimaScreen({super.key});

  @override
  State<VlasnikUpravljanjeZaposlenicimaScreen> createState() =>
      _VlasnikUpravljanjeZaposlenicimaScreenState();
}

class _VlasnikUpravljanjeZaposlenicimaScreenState
    extends State<VlasnikUpravljanjeZaposlenicimaScreen> {
  late UlogeProvider ulogeProvider;
  late KorisniciProvider korisniciProvider;

  SearchResult<Uloga>? ulogeResult;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ulogeProvider = context.read<UlogeProvider>();
    korisniciProvider = context.read<KorisniciProvider>();

    _initForm();
  }

  Future _initForm() async {
    ulogeResult = await ulogeProvider.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Vlasnik upravljanje zaposlenicima",
      Column(
        children: [
          _buildSearch(),
          _buildForm(),
        ],
      ),
    );
  }

  String? selectedItem;
  TextEditingController _imePrezimeGTEController = new TextEditingController();
  TextEditingController _korisnickoImeController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  bool? isDeleted;
  Widget _buildSearch() {
    return Padding(
      padding: EdgeInsets.all(25),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _imePrezimeGTEController,
                  decoration: InputDecoration(
                    labelText: 'Ime i prezime korisnika',
                    hintText: 'Ime i prezime korisnika',
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
                  onChanged: (value) async {
                    // _source.imePrezime = _imePrezimeGTEController.text;
                    // _source.filterServerSide();
                    // setState(() {});
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: DropdownButtonFormField<bool>(
                  value: isDeleted,
                  decoration: InputDecoration(
                    labelText: 'Obrisan',
                    hintText: 'Obrisan',
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
                  items: [
                    DropdownMenuItem<bool>(
                      value: null,
                      child: Text('---'),
                    ),
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text('Da'),
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text('Ne'),
                    ),
                  ],
                  onChanged: (bool? newValue) async {
                    isDeleted = newValue;
                    // _source.isDeleted = newValue;
                    // _source.filterServerSide();
                    setState(() {});
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedItem,
                  decoration: InputDecoration(
                    labelText: 'Uloga korisnika',
                    hintText: 'Uloga korisnika',
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
                  items: ulogeResult?.result
                          .where((e) =>
                              e.naziv != "Admin" &&
                              e.naziv != "Vlasnik" &&
                              e.naziv != "Kupac")
                          .map((Uloga uloga) {
                        return DropdownMenuItem<String>(
                          value: uloga.naziv,
                          child: Text(uloga.naziv!),
                        );
                      }).toList() ??
                      [],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedItem = newValue;
                      // _source.uloga = newValue.toString();
                      // _source.filterServerSide();
                      // setState(() {});
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _korisnickoImeController,
                  decoration: InputDecoration(
                    labelText: 'Korisničko ime',
                    hintText: 'Korisničko ime',
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
                  onChanged: (value) async {
                    // _source.korisnickoIme = _korisnickoImeController.text;
                    // _source.filterServerSide();
                    setState(() {});
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email korisnika',
                    hintText: 'Email korisnika',
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
                  onChanged: (value) async {
                    // _source.email = _emailController.text;
                    // _source.filterServerSide();
                    setState(() {});
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 0, 83, 86),
                  ),
                  child: InkWell(
                    onTap: () async {
                      // _imePrezimeGTEController.clear();
                      // _korisnickoImeController.clear();
                      // _emailController.clear();

                      setState(() {
                        selectedItem = null;
                        isDeleted = null;
                      });
                      // _source.imePrezime = '';
                      // _source.isDeleted = null;
                      // _source.korisnickoIme = '';
                      // _source.email = '';
                      // _source.uloga = '';
                      // _source.filterServerSide();
                      setState(() {});
                    },
                    child: Center(
                      child: Text(
                        "Očisti filtere",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
            children: [
              Text("filter po restoranu dodaj"),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 0, 83, 86),
                  ),
                  child: InkWell(
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VlasnikDodajRadnikaScreen()));
                      //     .then(
                      //   (value) {
                      //     if (value == true) _source.filterServerSide();
                      //   },
                      // );
                    },
                    child: Center(
                      child: Text(
                        "Dodaj radnika",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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

  Widget _buildForm() {
    return Container();
  }
}
