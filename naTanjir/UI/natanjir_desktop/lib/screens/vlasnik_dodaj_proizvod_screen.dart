import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/proizvod.dart';
import 'package:natanjir_desktop/models/restoran.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/vrsta_proizvodum.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:natanjir_desktop/providers/product_provider.dart';
import 'package:natanjir_desktop/providers/restoran_provider.dart';
import 'package:natanjir_desktop/providers/vrsta_proizvodum_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class VlasnikDodajProizvodScreen extends StatefulWidget {
  Proizvod? proizvod;
  VlasnikDodajProizvodScreen({super.key, this.proizvod});

  @override
  _VlasnikDodajProizvodScreenState createState() =>
      _VlasnikDodajProizvodScreenState();
}

class _VlasnikDodajProizvodScreenState
    extends State<VlasnikDodajProizvodScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ProductProvider proizvodProvider;
  late VrstaProizvodumProvider vrstaProizvodumProvider;
  late RestoranProvider restoranProvider;

  SearchResult<VrstaProizvodum>? vrstaProizvodumResult;
  SearchResult<Restoran>? restoranResult;
  SearchResult<Proizvod>? proizvodResult;

  bool isLoading = true;
  String? proizvodError;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  //TODO:FIX RIGHT OVERFLOW ON THIS SCREEN AND ON ADMIN FORMS
  @override
  void initState() {
    super.initState();
    restoranProvider = context.read<RestoranProvider>();
    proizvodProvider = context.read<ProductProvider>();
    vrstaProizvodumProvider = context.read<VrstaProizvodumProvider>();
    _initialValue = {
      'naziv': widget.proizvod?.naziv,
      'cijena': widget.proizvod?.cijena.toString(),
      'vrstaProizvodaId': widget.proizvod?.vrstaProizvodaId.toString(),
      'restoranId': widget.proizvod?.restoranId.toString(),
      'opis': widget.proizvod?.opis,
      'slika': widget.proizvod?.slika,
    };
    _initForm();
  }

  Future _initForm() async {
    proizvodResult = await proizvodProvider
        .get(filter: {'vlasnikRestoranaId': AuthProvider.korisnikId});
    restoranResult = await restoranProvider
        .get(filter: {'vlasnikId': AuthProvider.korisnikId});
    vrstaProizvodumResult = await vrstaProizvodumProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Dodaj proizvod",
      Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [isLoading ? Container() : _buildForm(), _saveRow()],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 200,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    image: widget.proizvod?.slika != null
                        ? DecorationImage(
                            image: MemoryImage(
                              base64Decode(widget.proizvod!.slika!),
                            ),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: AssetImage(
                                "assets/images/emptyProductImage.png"),
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
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'naziv',
                      decoration: InputDecoration(
                        labelText: 'Naziv proizvoda',
                        hintText: 'Naziv proizvoda',
                        errorText: proizvodError,
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
                        if (value != null && proizvodResult != null) {
                          final selectedRestoranId = await _formKey
                              .currentState?.fields['restoranId']?.value;

                          var nazivPostoji = proizvodResult!.result.any(
                              (proizvod) =>
                                  proizvod.restoranId.toString() ==
                                      selectedRestoranId &&
                                  proizvod.naziv == value);

                          if (nazivPostoji) {
                            proizvodError =
                                "Proizvod s tim imenom već postoji u odabranom restoranu.";
                          } else {
                            proizvodError = null;
                          }
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: buildFormBuilderTextField(
                      name: 'cijena',
                      labelText: 'Cijena (npr. 34 ili 34.00)',
                      hintText: 'Cijena',
                      validators: [
                        FormBuilderValidators.required(
                            errorText: 'Cijena je obavezna'),
                        FormBuilderValidators.match(
                          r'^\d+([.]\d{2})?$',
                          errorText:
                              'Unesite ispravnu cijenu, npr. 34 ili 34.00',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderDropdown(
                      validator: FormBuilderValidators.required(
                          errorText: "Obavezno polje."),
                      name: 'vrstaProizvodaId',
                      items: vrstaProizvodumResult?.result != null
                          ? vrstaProizvodumResult!.result
                              .map((item) => DropdownMenuItem(
                                    value: item.vrstaId.toString(),
                                    child: Text(item.naziv ?? ""),
                                  ))
                              .toList()
                          : [],
                      decoration: InputDecoration(
                        labelText: 'Vrsta proizvoda',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 108, 108, 108),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "Odaberite vrstu proizvoda",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  if (widget.proizvod == null)
                    Expanded(
                      child: FormBuilderDropdown(
                        validator: FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                        name: 'restoranId',
                        items: restoranResult?.result
                                .map((item) => DropdownMenuItem(
                                    value: item.restoranId.toString(),
                                    child: Text(item.naziv ?? "")))
                                .toList() ??
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
                        onChanged: (value) async {
                          if (value != null) {
                            final selectedRestoranId = await _formKey
                                .currentState?.fields['naziv']?.value;

                            var nazivPostoji = proizvodResult!.result.any(
                                (proizvod) => proizvod.naziv
                                    .toString()
                                    .contains(value.toString()));

                            if (nazivPostoji) {
                              proizvodError =
                                  "Proizvod s tim imenom već postoji u odabranom restoranu.";
                            } else {
                              proizvodError = null;
                            }
                            setState(() {});
                          }
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
                      name: 'opis',
                      decoration: InputDecoration(
                        labelText: 'Unesite opis',
                        hintText: 'Unesite opis',
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
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Obavezno polje."),
                      ]),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _saveRow() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
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
                if (widget.proizvod == null) {
                  await proizvodProvider.insert(req);
                } else {
                  await proizvodProvider.update(
                      widget.proizvod!.proizvodId!, req);
                }
                await QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: "Uspješno dodan/uređen proizvod!",
                );
                clearinput();
                if (mounted) setState(() {});
              } else {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: "Greška prilikom dodavanja/uređivanja proizvoda.",
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
    proizvodError = null;
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
