import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:natanjir_mobile/layouts/master_screen.dart';
import 'package:natanjir_mobile/models/proizvod.dart';
import 'package:natanjir_mobile/models/restoran.dart';
import 'package:natanjir_mobile/models/search_result.dart';
import 'package:natanjir_mobile/models/vrsta_proizvodum.dart';
import 'package:natanjir_mobile/providers/product_provider.dart';
import 'package:natanjir_mobile/providers/restoran_provider.dart';
import 'package:natanjir_mobile/providers/vrsta_proizvodum_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  Proizvod? proizvod;
  ProductDetailsScreen({super.key, this.proizvod});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ProductProvider productProvider;
  late VrstaProizvodumProvider vrstaProizvodumProvider;
  late RestoranProvider restoranProvider;
  SearchResult<VrstaProizvodum>? vrstaProizvodumResult;
  SearchResult<Restoran>? restoranResult;
  bool isLoading = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    productProvider = context.read<ProductProvider>();
    vrstaProizvodumProvider = context.read<VrstaProizvodumProvider>();
    restoranProvider = context.read<RestoranProvider>();
    // TODO: implement initState
    super.initState();

    _initialValue = {
      'naziv': widget.proizvod?.naziv,
      'cijena': widget.proizvod?.cijena.toString(),
      'vrstaProizvodaId': widget.proizvod?.vrstaProizvodaId.toString(),
      'restoranId': widget.proizvod?.restoranId.toString(),
      'opis': widget.proizvod?.opis,
    };

    initForm();
  }

  Future initForm() async {
    vrstaProizvodumResult = await vrstaProizvodumProvider.get();
    restoranResult = await restoranProvider.get();
    print("vr ${vrstaProizvodumResult?.result}");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Detalji",
        Column(
          children: [isLoading ? Container() : _buildForm(), _saveRow()],
        ));
  }

  Widget _buildForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(labelText: "Naziv"),
                      name: "naziv",
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Opis"),
                        name: "opis"),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderDropdown(
                      name: "vrstaProizvodaId",
                      decoration: InputDecoration(labelText: "Vrsta proizvoda"),
                      items: vrstaProizvodumResult?.result
                              .map((item) => DropdownMenuItem(
                                  value: item.vrstaId.toString(),
                                  child: Text(item.naziv ?? "")))
                              .toList() ??
                          [],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FormBuilderDropdown(
                      name: "restoranId",
                      decoration: InputDecoration(labelText: "Restoran"),
                      items: restoranResult?.result
                              .map((item) => DropdownMenuItem(
                                  value: item.restoranId.toString(),
                                  child: Text(item.naziv ?? "")))
                              .toList() ??
                          [],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FormBuilderTextField(
                        decoration: InputDecoration(labelText: "Cijena"),
                        name: "cijena"),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderField(
                      name: "imageId",
                      builder: (field) {
                        return InputDecorator(
                          decoration:
                              InputDecoration(labelText: "Odaberite sliku"),
                          child: ListTile(
                            leading: Icon(Icons.image),
                            title: Text("Select image"),
                            trailing: Icon(Icons.file_upload),
                            onTap: getImage,
                          ),
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  Widget _saveRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: () {
                _formKey.currentState?.saveAndValidate();
                debugPrint(_formKey.currentState?.value.toString());

                var request = Map.from(_formKey.currentState!.value);
                request['slika'] = _base64Image;

                if (widget.proizvod == null) {
                  productProvider.insert(request);
                } else {
                  productProvider.update(widget.proizvod!.proizvodId!, request);
                }
              },
              child: Text("Sačuvaj"))
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
