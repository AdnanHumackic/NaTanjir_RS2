import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/korisnici.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/providers/korisnici_provider.dart';
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

  SearchResult<Korisnici>? korisniciResult;

  final _formKey = GlobalKey<FormBuilderState>();

  late TabController _tabController;
  String? dateError;
  String? usernameError;
  String? confirmPasswordError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        resetFields();
      }
    });
    korisniciProvider = context.read<KorisniciProvider>();

    _initForm();
  }

  Future _initForm() async {
    korisniciResult = await korisniciProvider.get();
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
                      Tab(text: "Brisanje restorana"),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDodavanjeVlasnika(),
                      _buildDodavanjeRestorana(),
                      _buildBrisanjeRestorana()
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

  Widget _buildDodavanjeVlasnika() {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
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
                              .map((e) => e.korisnickoIme == value)
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
                            _formKey.currentState!.fields['lozinka']?.value !=
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
                          color: Color.fromARGB(97, 158, 158, 158),
                        ),
                        child: InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.fields['lozinka'] !=
                                    null &&
                                _formKey.currentState!
                                        .fields['lozinkaPotvrda'] !=
                                    null) {
                              var pw = generateRandomCharacters(10);
                              _formKey.currentState!.fields['lozinka']!
                                  .didChange(pw);
                              _formKey.currentState!.fields['lozinkaPotvrda']!
                                  .didChange(pw);
                            }
                          },
                          child: Center(
                            child: Text(
                              "Generiši lozinku",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
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
                        FormBuilderValidators.match(r'^[A-Z][a-zA-Z]*$',
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
                        FormBuilderValidators.match(r'^[A-Z][a-zA-Z]*$',
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
                          }
                        } else {
                          dateError = null;
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
    return Center(child: Text("Dodavanje restorana  "));
  }

  Widget _buildBrisanjeRestorana() {
    return Center(child: Text("Brisanje restorana  "));
  }

  Widget _saveVlasnikaRow() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(97, 158, 158, 158),
        ),
        child: InkWell(
          onTap: () async {
            var isValid = _formKey.currentState!.saveAndValidate();
            if (isValid == true) {
              var req = Map.from(_formKey.currentState!.value);
              DateTime dob = req['datumRodjenja'];
              req['datumRodjenja'] = dob.toIso8601String().split('T')[0];
              req['uloge'] = [2];
              req['slika'] = _base64Image;

              await korisniciProvider.insert(req);
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                title: "Uspješno dodan vlasnik!",
                text: "Da li želite isprintati podatke o vlasniku?",
                confirmBtnText: "Da",
                cancelBtnText: "Ne",
                onConfirmBtnTap: () {
                  createPdfFile(req);
                  Navigator.pop(context);
                },
              );
              if (mounted) setState(() {});
              setState(() {
                resetFields();
              });
            } else {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: "Greška prilikom dodavanja vlasnika.",
              );
            }
          },
          child: Center(
            child: Text(
              "Dodaj vlasnika",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
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
    _formKey.currentState?.reset();
    usernameError = null;
    dateError = null;
    confirmPasswordError = null;
    _base64Image = null;
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
