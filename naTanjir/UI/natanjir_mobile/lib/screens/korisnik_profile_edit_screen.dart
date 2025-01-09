import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/korisnici_provider.dart';
import 'package:natanjir_mobile/providers/utils.dart';
import 'package:natanjir_mobile/screens/korisnik_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class KorisnikProfileEditScreen extends StatefulWidget {
  KorisnikProfileEditScreen({super.key});

  @override
  State<KorisnikProfileEditScreen> createState() =>
      _KorisnikProfileEditScreenState();
}

class _KorisnikProfileEditScreenState extends State<KorisnikProfileEditScreen> {
  late KorisniciProvider korisniciProvider;

  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  bool promjenaLozinke = false;

  String? passwordError;
  String? newPasswordError;
  String? confirmPasswordError;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    korisniciProvider = context.read<KorisniciProvider>();
    _initialValue = {
      'ime': AuthProvider.ime,
      'prezime': AuthProvider.prezime,
      'telefon': AuthProvider.telefon,
      'slika': AuthProvider.slika,
      'lozinka': "",
      'novaLozinka': "",
      'lozinkaPotvrda': "",
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [SizedBox(height: 0), _buildForm(), _saveRow()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  image: AuthProvider.slika != null
                      ? DecorationImage(
                          image: MemoryImage(base64Decode(AuthProvider.slika!)),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: AssetImage("assets/images/noProfileImg.png"),
                          fit: BoxFit.cover,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            FormBuilderTextField(
              decoration: InputDecoration(
                labelText: 'Ime',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 108, 108, 108),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                hintText: "Ime",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              name: 'ime',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Obavezno polje."),
                FormBuilderValidators.minLength(2,
                    errorText: "Minimalna dužina imena je 2 znaka."),
                FormBuilderValidators.maxLength(40,
                    errorText: "Maksimalna dužina imena je 40 znakova."),
                FormBuilderValidators.match(r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ]*$',
                    errorText:
                        "Ime mora počinjati sa velikim slovom i smije sadržavati samo slova.")
              ]),
            ),
            SizedBox(height: 15),
            FormBuilderTextField(
              decoration: InputDecoration(
                labelText: 'Prezime',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 108, 108, 108),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                hintText: 'Prezime',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              name: "prezime",
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Obavezno polje."),
                FormBuilderValidators.minLength(2,
                    errorText: "Minimalna dužina prezimena je 2 znaka."),
                FormBuilderValidators.maxLength(40,
                    errorText: "Maksimalna dužina prezimena je 40 znakova."),
                FormBuilderValidators.match(r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ]*$',
                    errorText:
                        "Prezime mora počinjati sa velikim slovom i smije sadržavati samo slova.")
              ]),
            ),
            SizedBox(height: 15),
            FormBuilderTextField(
              decoration: InputDecoration(
                labelText: 'Broj telefona',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 108, 108, 108),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                hintText: "Broj telefona",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              name: 'telefon',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Obavezno polje."),
                FormBuilderValidators.match(r'^\+\d{7,15}$',
                    errorText:
                        "Telefon mora imati od 7 do 15 cifara \ni počinjati znakom +."),
              ]),
            ),
            SizedBox(height: 15),
            FormBuilderField(
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
            SizedBox(height: 15),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: FormBuilderCheckbox(
                      name: 'promjenaLozinke',
                      title: Text("Promijeni lozinku"),
                      activeColor: Color.fromARGB(255, 0, 83, 86),
                      onChanged: (value) => {
                        setState(() {
                          promjenaLozinke = value!;
                        })
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 15),
            if (promjenaLozinke == true)
              Container(
                child: Row(
                  children: [
                    Expanded(
                        child: FormBuilderTextField(
                      decoration: InputDecoration(
                        errorText: passwordError,
                        labelText: 'Stara lozinka',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 108, 108, 108),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        hintText: "Stara lozinka",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: true,
                      name: 'lozinka',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                      ]),
                      onChanged: (value) {
                        if (value != AuthProvider.password) {
                          passwordError = "Unesite ispravanu lozinku.";
                        } else {
                          passwordError = null;
                        }
                        setState(() {});
                      },
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            SizedBox(height: 15),
            if (promjenaLozinke == true)
              Container(
                child: Row(
                  children: [
                    Expanded(
                        child: FormBuilderTextField(
                      decoration: InputDecoration(
                        errorText: newPasswordError,
                        labelText: 'Nova lozinka',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 108, 108, 108),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        hintText: "Nova lozinka",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: true,
                      name: 'novaLozinka',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                      ]),
                      onChanged: (value) {
                        if (value != null && value == AuthProvider.password) {
                          newPasswordError =
                              "Nova lozinka se ne smije podudarati \nsa starom lozinkom.";
                        } else {
                          newPasswordError = null;
                        }
                        setState(() {});
                      },
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            SizedBox(height: 15),
            if (promjenaLozinke == true)
              Container(
                child: Row(
                  children: [
                    Expanded(
                        child: FormBuilderTextField(
                      decoration: InputDecoration(
                        errorText: confirmPasswordError,
                        labelText: 'Potvrda lozinke',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 108, 108, 108),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        hintText: "Potvrda lozinke",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: true,
                      name: 'lozinkaPotvrda',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                      ]),
                      onChanged: (value) {
                        if (value != null &&
                            _formKey.currentState!.fields['novaLozinka']
                                    ?.value !=
                                value) {
                          confirmPasswordError =
                              "Lozinka potvrda se mora podudarati sa \nnovom lozinkom.";
                        } else {
                          confirmPasswordError = null;
                        }
                        setState(() {});
                      },
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _saveRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 0, 83, 86),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              fixedSize: Size(double.infinity, 40),
            ),
            onPressed: () async {
              var isValid = _formKey.currentState!.saveAndValidate();
              if (isValid == true) {
                var req = Map.from(_formKey.currentState!.value);
                req['slika'] = _base64Image;
                req['email'] = AuthProvider.email;
                req['korisnickoIme'] = AuthProvider.username;
                await korisniciProvider.update(AuthProvider.korisnikId!, req);

                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: "Uspješno modifikovan profil",
                );

                AuthProvider.ime = req['ime'];
                AuthProvider.prezime = req['prezime'];
                AuthProvider.telefon = req['telefon'];
                AuthProvider.slika = req['slika'];

                setState(() {});

                if (req['lozinka'] != null &&
                    req['novaLozinka'] != null &&
                    req['lozinkaPotvrda'] != null &&
                    promjenaLozinke == true) {
                  AuthProvider.password = req['novaLozinka'];

                  AuthProvider.slika = req['slika'];

                  setState(() {
                    _formKey.currentState?.fields['promijeniLozinku']
                        ?.didChange(false);
                    _formKey.currentState?.fields['lozinka']?.didChange(null);
                    _formKey.currentState?.fields['novaLozinka']
                        ?.didChange(null);
                    _formKey.currentState?.fields['lozinkaPotvrda']
                        ?.didChange(null);
                    passwordError = null;
                    newPasswordError = null;
                    confirmPasswordError = null;
                  });
                }
              } else {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: "Greška prilikom modifikovanja profila.",
                );
              }
            },
            child: Text(
              "Sačuvaj",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
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
}
