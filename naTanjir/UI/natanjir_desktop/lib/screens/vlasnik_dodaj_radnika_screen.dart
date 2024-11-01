import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/korisnici.dart';
import 'package:natanjir_desktop/models/restoran.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/uloga.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:natanjir_desktop/providers/korisnici_provider.dart';
import 'package:natanjir_desktop/providers/restoran_provider.dart';
import 'package:natanjir_desktop/providers/uloga_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class VlasnikDodajRadnikaScreen extends StatefulWidget {
  @override
  _VlasnikDodajRadnikaScreenState createState() =>
      _VlasnikDodajRadnikaScreenState();
}

class _VlasnikDodajRadnikaScreenState extends State<VlasnikDodajRadnikaScreen> {
  late KorisniciProvider korisniciProvider;
  late RestoranProvider restoranProvider;
  late UlogeProvider ulogeProvider;

  SearchResult<Korisnici>? korisniciResult;
  SearchResult<Restoran>? restoranResult;
  SearchResult<Uloga>? ulogeResult;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final _formKey = GlobalKey<FormBuilderState>();
  String? dateError;
  String? usernameError;
  String? confirmPasswordError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    korisniciProvider = context.read<KorisniciProvider>();
    restoranProvider = context.read<RestoranProvider>();
    ulogeProvider = context.read<UlogeProvider>();
    _initForm();
  }

  Future _initForm() async {
    korisniciResult = await korisniciProvider.get();
    restoranResult = await restoranProvider.get();
    ulogeResult = await ulogeProvider.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Dodaj radnika",
      Column(
        children: [_buildForm()],
      ),
    );
  }

  Widget _buildForm() {
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
                          color: Color.fromARGB(255, 0, 83, 86),
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
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderDropdown<String>(
                      name: 'restoranId',
                      validator: FormBuilderValidators.required(
                        errorText: "Obavezno polje.",
                      ),
                      items: restoranResult?.result
                              .where((element) =>
                                  element.vlasnikId == AuthProvider.korisnikId)
                              .map((Restoran restoran) {
                            return DropdownMenuItem<String>(
                              value: restoran.restoranId.toString(),
                              child: Text(restoran.naziv!),
                            );
                          }).toList() ??
                          [],
                      decoration: InputDecoration(
                        labelText: 'Restoran',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 108, 108, 108),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Odaberite restoran",
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
                  Expanded(
                    child: FormBuilderDropdown<String>(
                      name: 'uloge',
                      validator: FormBuilderValidators.required(
                        errorText: "Obavezno polje.",
                      ),
                      items: ulogeResult?.result
                              .where((element) =>
                                  element.naziv != "Admin" &&
                                  element.naziv != "Vlasnik" &&
                                  element.naziv != "Kupac")
                              .map((Uloga uloga) {
                            return DropdownMenuItem<String>(
                              value: uloga.ulogaId.toString(),
                              child: Text(uloga.naziv!),
                            );
                          }).toList() ??
                          [],
                      decoration: InputDecoration(
                        labelText: 'Uloga',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 108, 108, 108),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Odaberite ulogu",
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
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Color.fromARGB(97, 158, 158, 158),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Napomena: Printanje podataka će biti omogućeno nakon dodavanja radnika.",
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
                  Expanded(child: _saveRow()),
                  SizedBox(width: 15),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget _saveRow() {
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
              var isValid = _formKey.currentState!.saveAndValidate();
              if (isValid == true) {
                var req = Map.from(_formKey.currentState!.value);
                req['slika'] = _base64Image;
                DateTime dob = req['datumRodjenja'];
                req['datumRodjenja'] = dob.toIso8601String().split('T')[0];
                req['uloge'] = [_formKey.currentState!.fields['uloge']?.value];
                // if (widget.proizvod == null) {
                //   await proizvodProvider.insert(req);
                // } else {
                //   await proizvodProvider.update(
                //       widget.proizvod!.proizvodId!, req);
                // }
                await korisniciProvider.insert(req);
                await QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: "Uspješno dodan/uređen radnik!",
                );
                clearinput();
                if (mounted) setState(() {});
              } else {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: "Greška prilikom dodavanja/uređivanja radnika.",
                );
              }
            },
            child: Center(
              child: Text(
                "Sačuvaj",
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

  void clearinput() {
    _formKey.currentState?.reset();
    usernameError = null;
    dateError = null;
    confirmPasswordError = null;
  }
}
