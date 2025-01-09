import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/korisnici.dart';
import 'package:natanjir_desktop/models/ocjena_restoran.dart';
import 'package:natanjir_desktop/models/restoran.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/vrsta_restorana.dart';
import 'package:natanjir_desktop/providers/korisnici_provider.dart';
import 'package:natanjir_desktop/providers/narudzba_provider.dart';
import 'package:natanjir_desktop/providers/ocjena_restoran_provider.dart';
import 'package:natanjir_desktop/providers/restoran_provider.dart';
import 'package:natanjir_desktop/providers/utils.dart';
import 'package:natanjir_desktop/providers/vrsta_restorana_provider.dart';
import 'package:natanjir_desktop/screens/restoran_details_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminUpravljanjeRestoranimaScreen extends StatefulWidget {
  @override
  _AdminUpravljanjeRestoranimaScreenState createState() =>
      _AdminUpravljanjeRestoranimaScreenState();
}

class _AdminUpravljanjeRestoranimaScreenState
    extends State<AdminUpravljanjeRestoranimaScreen>
    with SingleTickerProviderStateMixin {
  late KorisniciProvider korisniciProvider;
  late VrstaRestoranaProvider vrstaRestoranaProvider;
  late RestoranProvider restoranProvider;

  SearchResult<Korisnici>? korisniciResult;
  SearchResult<VrstaRestorana>? vrstaRestoranaResult;
  SearchResult<Restoran>? restoranResult;
  late RestoranDataSource _source;
  int page = 1;
  int pageSize = 10;
  int count = 10;
  bool _isLoading = false;

  @override
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Map<String, dynamic> searchRequest = {
    'isKorisniciUlogeIncluded': true,
  };

  final _formKeyVlas = GlobalKey<FormBuilderState>();
  final _formKeyRest = GlobalKey<FormBuilderState>();

  late TabController _tabController;
  String? dateError;
  String? usernameError;
  String? confirmPasswordError;
  String? restNameErr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        resetFields();
        _initForm();
      }
    });
    korisniciProvider = context.read<KorisniciProvider>();
    vrstaRestoranaProvider = context.read<VrstaRestoranaProvider>();
    restoranProvider = context.read<RestoranProvider>();
    _source = RestoranDataSource(
        provider: restoranProvider,
        context: context,
        nazivGTE: _nazivRestoranaController.text,
        isDeleted: isDeleted);
    _initForm();
  }

  Future _initForm() async {
    korisniciResult = await korisniciProvider.get(filter: searchRequest);
    vrstaRestoranaResult = await vrstaRestoranaProvider.get();
    restoranResult = await restoranProvider.get();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Upravljanje restoranima",
      Padding(
        padding: EdgeInsets.all(25),
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(0),
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: "Dodavanje vlasnika"),
                      Tab(text: "Dodavanje restorana"),
                      Tab(text: "Pregled/brisanje restorana"),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDodavanjeVlasnika(),
                      _buildDodavanjeRestorana(),
                      _buildBrisanjeRestorana(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController _nazivRestoranaController = TextEditingController();
  bool? isDeleted;
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _nazivRestoranaController,
              decoration: InputDecoration(
                labelText: 'Naziv restorana',
                hintText: 'Naziv restorana',
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
                _source.nazivRestorana = _nazivRestoranaController.text;
                _source.filterServerSide();
                setState(() {});
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
                _source.isDeleted = newValue;
                _source.filterServerSide();
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
                  _nazivRestoranaController.clear();

                  setState(() {
                    isDeleted = null;
                  });
                  _source.nazivRestorana = '';
                  _source.isDeleted = null;
                  _source.filterServerSide();
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
    );
  }

  Widget _buildDodavanjeVlasnika() {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _formKeyVlas,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'korisnickoIme',
                      decoration: InputDecoration(
                        labelText: 'Korisničko ime',
                        hintText: 'Korisničko ime',
                        errorText: usernameError,
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
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                      ]),
                      onChanged: (value) async {
                        if (value != null && korisniciResult != null) {
                          var username = await korisniciResult!.result
                              .map((e) =>
                                  e.korisnickoIme!.toLowerCase() ==
                                  value.toLowerCase())
                              .toList();

                          if (username.contains(true)) {
                            usernameError =
                                "Korisnik s tim imenom već postoji.";
                            setState(() {});
                          } else {
                            usernameError = null;
                          }
                        }

                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        labelText: 'Lozinka',
                        errorText: confirmPasswordError,
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 108, 108, 108),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Lozinka",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      name: 'lozinka',
                      obscureText: true,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                      ]),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        errorText: confirmPasswordError,
                        labelText: 'Lozinka potvrda',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 108, 108, 108),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Lozinka potvrda",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      name: 'lozinkaPotvrda',
                      obscureText: true,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                      ]),
                      onChanged: (value) {
                        if (value != null &&
                            _formKeyVlas
                                    .currentState!.fields['lozinka']?.value !=
                                value) {
                          confirmPasswordError =
                              "Lozinka potvrda se mora podudarati sa unesenom lozinkom.";
                        } else {
                          confirmPasswordError = null;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 0, 83, 86),
                        ),
                        child: InkWell(
                          onTap: () async {
                            if (_formKeyVlas.currentState!.fields['lozinka'] !=
                                    null &&
                                _formKeyVlas.currentState!
                                        .fields['lozinkaPotvrda'] !=
                                    null) {
                              var pw = generateRandomCharacters(10);
                              _formKeyVlas.currentState!.fields['lozinka']!
                                  .didChange(pw);
                              _formKeyVlas
                                  .currentState!.fields['lozinkaPotvrda']!
                                  .didChange(pw);
                            }
                          },
                          child: Center(
                            child: Text(
                              "Generiši lozinku",
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
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: buildFormBuilderTextField(
                      name: 'ime',
                      labelText: 'Ime',
                      hintText: "Ime",
                      validators: [
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                        FormBuilderValidators.minLength(2,
                            errorText: "Minimalna dužina imena je 2 znaka."),
                        FormBuilderValidators.maxLength(40,
                            errorText:
                                "Maksimalna dužina imena je 40 znakova."),
                        FormBuilderValidators.match(
                            r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ]*$',
                            errorText:
                                "Ime mora počinjati sa velikim slovom i smije sadržavati samo slova.")
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: buildFormBuilderTextField(
                      name: 'prezime',
                      labelText: 'Prezime',
                      hintText: "Prezime",
                      validators: [
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                        FormBuilderValidators.minLength(2,
                            errorText:
                                "Minimalna dužina prezimena je 2 znaka."),
                        FormBuilderValidators.maxLength(40,
                            errorText:
                                "Maksimalna dužina prezimena je 40 znakova."),
                        FormBuilderValidators.match(
                            r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ]*$',
                            errorText:
                                "Prezime mora počinjati sa velikim slovom i smije sadržavati samo slova.")
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: buildFormBuilderTextField(
                      name: 'email',
                      labelText: 'Email',
                      hintText: "Email",
                      validators: [
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                        FormBuilderValidators.email(
                            errorText: "Email nije validan.")
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: FormBuilderDateTimePicker(
                      decoration: InputDecoration(
                        errorText: dateError,
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: Icon(Icons.calendar_today),
                        hintText: "Datum rođenja",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      name: 'datumRodjenja',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                      ]),
                      onChanged: (value) async {
                        if (value != null) {
                          DateTime date = DateTime.now();
                          int age = date.year - value.year;

                          if (age < 18 || value!.isAfter(DateTime.now())) {
                            dateError =
                                "Korisnik mora biti stariji od 18 godina i datum rođenja ne smije \nbiti stariji od današnjeg.";
                          } else {
                            dateError = null;
                          }
                        } else {
                          dateError = null;
                          setState(() {});
                        }

                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: buildFormBuilderTextField(
                      name: 'telefon',
                      labelText: 'Broj telefona',
                      hintText: "Broj telefona",
                      validators: [
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                        FormBuilderValidators.match(r'^\+\d{7,15}$',
                            errorText:
                                "Telefon mora imati od 7 do 15 cifara i počinjati znakom +."),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: FormBuilderField(
                      name: "slika",
                      builder: (field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Odaberite sliku',
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
                          child: ListTile(
                            leading: Icon(Icons.image),
                            title: Text("Select image"),
                            trailing: Icon(Icons.file_upload),
                            onTap: getImage,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(97, 158, 158, 158),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Napomena: Printanje podataka će biti omogućeno nakon dodavanja vlasnika.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _saveVlasnikaRow()),
                  SizedBox(width: 15),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDodavanjeRestorana() {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _formKeyRest,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: FormBuilderTextField(
                      name: 'naziv',
                      decoration: InputDecoration(
                        labelText: 'Naziv restorana',
                        hintText: 'Naziv restorana',
                        errorText: restNameErr,
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
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                        FormBuilderValidators.minLength(2,
                            errorText: "Minimalna dužina naziva je 2 znaka."),
                        FormBuilderValidators.maxLength(40,
                            errorText: "Maksimalna dužina naziva je 40 znaka."),
                      ]),
                      onChanged: (value) async {
                        if (value != null && korisniciResult != null) {
                          var username = await restoranResult!.result
                              .map((e) =>
                                  e.naziv!.toLowerCase() == value.toLowerCase())
                              .toList();

                          if (username.contains(true)) {
                            restNameErr = "Restoran s tim imenom već postoji.";
                            setState(() {});
                          } else {
                            usernameError = null;
                          }
                        }

                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Flexible(
                    child: buildFormBuilderTextField(
                      name: 'radnoVrijemeOd',
                      labelText: 'Radno vrijeme OD',
                      hintText: "Radno vrijeme OD",
                      validators: [
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                        FormBuilderValidators.match(
                            r'^(?:[01]\d|2[0-3]):[0-5]\d$',
                            errorText: "Neispravan format vremena. (HH:mm)"),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: buildFormBuilderTextField(
                      name: 'radnoVrijemeDo',
                      labelText: 'Radno vrijeme DO',
                      hintText: "Radno vrijeme DO",
                      validators: [
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                        FormBuilderValidators.match(
                          r'^(?:[01]\d|2[0-3]):[0-5]\d$',
                          errorText: "Neispravan format vremena. (HH:mm)",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Flexible(
                    child: FormBuilderDropdown(
                      validator: FormBuilderValidators.required(
                          errorText: "Obavezno polje."),
                      name: 'vrstaRestoranaId',
                      items: vrstaRestoranaResult?.result != null
                          ? vrstaRestoranaResult!.result
                              .map((item) => DropdownMenuItem(
                                    value: item.vrstaId.toString(),
                                    child: Text(item.naziv ?? ""),
                                  ))
                              .toList()
                          : [],
                      decoration: InputDecoration(
                        labelText: 'Vrsta restorana',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 108, 108, 108),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Odaberite vrstu restorana",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: FormBuilderDropdown(
                      name: 'vlasnikId',
                      validator: FormBuilderValidators.required(
                          errorText: "Obavezno polje."),
                      items: (korisniciResult?.result ?? [])
                              .where((e) =>
                                  e.korisniciUloges?.any(
                                      (u) => u.uloga?.naziv == "Vlasnik") ??
                                  false)
                              .map((item) => DropdownMenuItem(
                                  value: item.korisnikId.toString(),
                                  child: Text(item.korisnickoIme ?? "")))
                              .toList() ??
                          [],
                      decoration: InputDecoration(
                        labelText: 'Vlasnik restorana',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 108, 108, 108),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Odaberite vlasnika restorana",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Flexible(
                    child: buildFormBuilderTextField(
                      name: 'lokacija',
                      labelText: 'Lokacija restorana',
                      hintText: "Lokacija restorana",
                      validators: [
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                        FormBuilderValidators.minLength(2,
                            errorText: "Minimalna dužina lokacije je 2 znaka."),
                        FormBuilderValidators.maxLength(40,
                            errorText:
                                "Maksimalna dužina lokacije je 40 znaka."),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Flexible(
                    child: FormBuilderField(
                      name: "slikaRest",
                      builder: (field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Odaberite sliku',
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
                          child: ListTile(
                            leading: Icon(Icons.image),
                            title: Text("Select image"),
                            trailing: Icon(Icons.file_upload),
                            onTap: getImage,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _saveRestoranRow()),
                  SizedBox(width: 15),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrisanjeRestorana() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSearch(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: AdvancedPaginatedDataTable(
                columns: const [
                  DataColumn(label: Text("Naziv")),
                  DataColumn(label: Text("Lokacija")),
                  DataColumn(label: Text("Radno vrijeme OD")),
                  DataColumn(label: Text("Radno vrijeme DO")),
                  DataColumn(label: Text("Obrisan")),
                  DataColumn(label: Text("Obriši restoran")),
                ],
                source: _source,
                addEmptyRows: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveVlasnikaRow() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
          width: 250,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 0, 83, 86),
          ),
          child: InkWell(
            onTap: () async {
              var isValid = _formKeyVlas.currentState!.saveAndValidate();
              if (isValid == true) {
                try {
                  var req = Map.from(_formKeyVlas.currentState!.value);
                  DateTime dob = req['datumRodjenja'];
                  req['datumRodjenja'] = dob.toIso8601String().split('T')[0];
                  req['uloge'] = [2];
                  req['slika'] = _base64Image;

                  await korisniciProvider.insert(req);

                  bool shouldPrint = await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Uspješno dodan vlasnik!"),
                        content:
                            Text("Da li želite isprintati podatke o vlasniku?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text("Ne"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text("Da"),
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldPrint == true) {
                    createPdfFile(req);
                  }

                  resetFields();
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Greška"),
                        content: Text(
                            "Došlo je do greške prilikom dodavanja vlasnika."),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("U redu"),
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            },
            child: Center(
              child: Text(
                "Dodaj vlasnika",
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
    );
  }

  Widget _saveRestoranRow() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
          width: 250,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 0, 83, 86),
          ),
          child: InkWell(
            onTap: () async {
              var isValid = _formKeyRest.currentState!.saveAndValidate();
              if (isValid == true) {
                var req = Map.from(_formKeyRest.currentState!.value);
                req['slika'] = _base64Image;

                await restoranProvider.insert(req);
                await QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: "Uspješno dodan restoran!",
                );
                if (mounted) setState(() {});
                setState(() {
                  resetFields();
                });
              }
            },
            child: Center(
              child: Text(
                "Dodaj restoran",
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
    );
  }

  Widget buildFormBuilderTextField({
    required String name,
    required String labelText,
    String? hintText,
    List<String? Function(String?)>? validators,
  }) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
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
      validator: FormBuilderValidators.compose(validators ?? []),
    );
  }

  File? _image;
  String? _base64Image;

  void getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }
  }

  void resetFields() {
    _formKeyVlas.currentState?.reset();
    usernameError = null;
    dateError = null;
    confirmPasswordError = null;
    _base64Image = null;

    _formKeyRest.currentState?.reset();
    restNameErr = null;
  }

  String generateRandomCharacters(int length) {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    print(String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    ));
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  void createPdfFile(Map req) async {
    final pdf = pw.Document();

    final img = await rootBundle.load('assets/images/naTanjirLogoMini.png');
    final imageBytes = img.buffer.asUint8List();
    pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                      alignment: pw.Alignment.center,
                      height: 150,
                      width: 100,
                      child: image1,
                    ),
                    pw.SizedBox(height: 20),
                    pw.Text('Podaci o vlasniku:',
                        style: pw.TextStyle(fontSize: 24)),
                    pw.SizedBox(height: 20),
                    pw.Text('Ime: ${req['ime']}',
                        style: pw.TextStyle(fontSize: 18)),
                    pw.Text('Prezime: ${req['prezime']}',
                        style: pw.TextStyle(fontSize: 18)),
                    pw.Text('Email: ${req['email']}',
                        style: pw.TextStyle(fontSize: 18)),
                    pw.Text(
                      'Korisnicko ime: ${req['korisnickoIme']}',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Lozinka: ${req['lozinka']}',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 40),
                    pw.Divider(thickness: 1),
                    pw.Text(
                      'Hvala sto koristite nas sistem!\nMolimo Vas da nakon prijave promijenite svoju lozinku.',
                      style: pw.TextStyle(fontSize: 20),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Divider(thickness: 1),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}

class RestoranDataSource extends AdvancedDataTableSource<Restoran> {
  List<Restoran>? data = [];
  final RestoranProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String nazivRestorana = "";
  dynamic filter;
  bool? isDeleted;
  BuildContext context;
  RestoranDataSource(
      {required this.provider,
      required this.context,
      required String nazivGTE,
      bool? isDeleted});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(
        onSelectChanged: (selected) => {
              if (selected == true)
                {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RestoranDetailsScreen(
                            odabraniRestoran: item,
                            avgOcjena: "",
                          ))),
                }
            },
        cells: [
          DataCell(Text(
            item!.naziv.toString(),
            style: TextStyle(fontSize: 15),
          )),
          DataCell(Text(
            item.lokacija.toString(),
            style: TextStyle(fontSize: 15),
          )),
          DataCell(Text(item.radnoVrijemeOd.toString(),
              style: TextStyle(fontSize: 15))),
          DataCell(Text(item.radnoVrijemeDo.toString(),
              style: TextStyle(fontSize: 15))),
          DataCell(
            Text(
              item?.isDeleted == true ? 'Da' : 'Ne',
              style: TextStyle(fontSize: 15),
            ),
          ),
          if (item.isDeleted == false)
            DataCell(
              TextButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                          "Da li ste sigurni da želite obrisati restoran?"),
                      content: Text(
                          "Ovo će obrisati restoran kao i sve njegove proizvode iz ponude."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Ne"),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            try {
                              await provider.delete(item.restoranId!);

                              filterServerSide();
                            } catch (e) {
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                      "Greška prilikom brisanja restorana!"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Text("Da"),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  child: Text(
                    "Obriši",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          if (item.isDeleted == true)
            DataCell(
              TextButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                          "Da li ste sigurni da želite vratiti restoran u ponudu?"),
                      content: Text(
                          "Ovo će vratiti restoran u ponudu kao i sve njegove proizvode iz ponude."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Ne"),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            try {
                              var upd = {
                                'radnoVrijemeOd': item.radnoVrijemeOd,
                                'radnoVrijemeDo': item.radnoVrijemeDo,
                                'slika': item.slika,
                                'lokacija': item.lokacija,
                                'isDeleted': false,
                                'vrijemeBrisanja': null,
                              };

                              await provider.update(item.restoranId!, upd);

                              filterServerSide();
                            } catch (e) {
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                      "Greška prilikom vraćanja restorana u ponudu!"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Text("Da"),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  child: Text(
                    "Vrati u ponudu",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 0, 83, 86),
                    ),
                  ),
                ),
              ),
            ),
        ]);
  }

  void filterServerSide() {
    setNextView();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;

  @override
  Future<RemoteDataSourceDetails<Restoran>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'nazivGTE': nazivRestorana,
      'isDeleted': isDeleted,
      'isVrstaRestoranaIncluded': true
    };

    try {
      var result =
          await provider.get(filter: filter, page: page, pageSize: pageSize);

      data = result!.result;
      count = result!.count;
    } on Exception catch (e) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: e.toString(),
          width: 300);
    }

    return RemoteDataSourceDetails(count, data!);
  }
}
