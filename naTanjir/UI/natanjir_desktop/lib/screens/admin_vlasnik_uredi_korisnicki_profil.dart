import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/korisnici.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/providers/korisnici_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AdminVlasnikUrediKorisnickiProfilScreen extends StatefulWidget {
  Korisnici? odabraniKorisnik;
  AdminVlasnikUrediKorisnickiProfilScreen(
      {super.key, required this.odabraniKorisnik});
  @override
  _AdminVlasnikUrediKorisnickiProfilScreenState createState() =>
      _AdminVlasnikUrediKorisnickiProfilScreenState();
}

class _AdminVlasnikUrediKorisnickiProfilScreenState
    extends State<AdminVlasnikUrediKorisnickiProfilScreen> {
  late KorisniciProvider korisniciProvider;

  SearchResult<Korisnici>? korisniciResult;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  String? usernameError;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'korisnickoIme': widget.odabraniKorisnik?.korisnickoIme,
      'ime': widget.odabraniKorisnik?.ime,
      'prezime': widget.odabraniKorisnik?.prezime,
      'email': widget.odabraniKorisnik?.email,
      'telefon': widget.odabraniKorisnik?.telefon,
      'datumRodjenja': widget.odabraniKorisnik?.datumRodjenja,
      'slika': widget.odabraniKorisnik?.slika,
    };
    korisniciProvider = context.read<KorisniciProvider>();

    _initForm();
  }

  Future _initForm() async {
    korisniciResult = await korisniciProvider.get();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Uređivanje korisnikovog profila",
      Column(
        children: [
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 200,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                      image: widget.odabraniKorisnik?.slika != null
                          ? DecorationImage(
                              image: MemoryImage(
                                base64Decode(widget.odabraniKorisnik!.slika!),
                              ),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image:
                                  AssetImage("assets/images/noProfileImg.png"),
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
                SizedBox(height: 20),
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
                            errorText: "Obavezno polje.",
                          ),
                        ]),
                        onChanged: (value) async {
                          if (value != null && korisniciResult != null) {
                            var username = await korisniciResult!.result
                                .map((e) =>
                                    e.korisnickoIme!.toLowerCase() ==
                                        value.toLowerCase() &&
                                    e.korisnikId !=
                                        widget.odabraniKorisnik!.korisnikId)
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
                      child: buildFormBuilderTextField(
                        name: 'ime',
                        labelText: 'Ime',
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
                        validators: [
                          FormBuilderValidators.required(
                              errorText: "Obavezno polje."),
                          FormBuilderValidators.email(
                              errorText: "Email nije validan."),
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: buildFormBuilderTextField(
                        name: 'telefon',
                        labelText: 'Broj telefona',
                        validators: [
                          FormBuilderValidators.required(
                              errorText: "Obavezno polje."),
                          FormBuilderValidators.match(r'^\+\d{7,15}$',
                              errorText:
                                  "Telefon mora imati od 7 do 15 cifara i počinjati znakom +."),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                _saveRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _saveRow() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
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
                if (widget.odabraniKorisnik?.korisnikId != null) {
                  await korisniciProvider.update(
                      widget.odabraniKorisnik!.korisnikId!, req);
                }
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Uspješno uređen profil!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );

                Navigator.pop(context, true);
                if (mounted) setState(() {});
              } else {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: "Greška prilikom uređivanja profila.",
                );
              }
            },
            child: Center(
              child: Text(
                "Sačuvaj promjene",
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

  File? _image;
  String? _base64Image;

  void getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }
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
}
