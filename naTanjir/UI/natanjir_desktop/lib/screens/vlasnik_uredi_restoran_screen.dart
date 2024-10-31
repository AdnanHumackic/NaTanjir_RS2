import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/restoran.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/vrsta_restorana.dart';
import 'package:natanjir_desktop/providers/restoran_provider.dart';
import 'package:natanjir_desktop/providers/vrsta_restorana_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class VlasnikUrediRestoranScreen extends StatefulWidget {
  Restoran? odabraniRestoran;
  VlasnikUrediRestoranScreen({super.key, required this.odabraniRestoran});

  @override
  State<VlasnikUrediRestoranScreen> createState() =>
      _VlasnikUrediRestoranScreenState();
}

class _VlasnikUrediRestoranScreenState
    extends State<VlasnikUrediRestoranScreen> {
  late VrstaRestoranaProvider vrstaRestoranaProvider;
  late RestoranProvider restoranProvider;

  SearchResult<VrstaRestorana>? vrstaRestoranaResult;
  SearchResult<Restoran>? restoranResult;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vrstaRestoranaProvider = context.read<VrstaRestoranaProvider>();
    restoranProvider = context.read<RestoranProvider>();
    _initialValue = {
      'radnoVrijemeOd': widget.odabraniRestoran?.radnoVrijemeOd,
      'radnoVrijemeDo': widget.odabraniRestoran?.radnoVrijemeDo,
      'slika': widget.odabraniRestoran?.slika,
      'lokacija': widget.odabraniRestoran?.lokacija,
      'isDeleted': widget.odabraniRestoran?.isDeleted,
      'vrijemeBrisanja': null
    };
    _initForm();
  }

  Future _initForm() async {
    vrstaRestoranaResult = await vrstaRestoranaProvider.get();
    restoranResult = await restoranProvider.get();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Vlasnik uredi restoran",
      Column(
        children: [
          _buildForm(),
        ],
      ),
    );
  }

  String? restNameErr;

  Widget _buildForm() {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: FormBuilderTextField(
                      name: 'naziv',
                      initialValue: widget.odabraniRestoran!.naziv,
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
                      enabled: false,
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
                    child: FormBuilderTextField(
                      name: 'vrstaRestoranaId',
                      initialValue:
                          widget.odabraniRestoran!.vrstaRestorana!.naziv,
                      decoration: InputDecoration(
                        labelText: 'Vrsta restorana',
                        hintText: 'Vrsta restorana',
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
                      enabled: false,
                    ),
                  ),
                  SizedBox(
                    width: 15,
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
              var isValid = _formKey.currentState!.saveAndValidate();
              if (isValid == true) {
                var req = Map.from(_formKey.currentState!.value);
                req['slika'] = _base64Image;

                await restoranProvider.update(
                    widget.odabraniRestoran!.restoranId!, req);
                await QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: "Uspješno uređen restoran!",
                );
                if (mounted) setState(() {});
                Navigator.pop(context, true);
                setState(() {});
              } else {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: "Greška prilikom uređivanja restorana.",
                );
              }
            },
            child: Center(
              child: Text(
                "Završi uređivanje",
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
