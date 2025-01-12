import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/vrsta_restorana.dart';
import 'package:natanjir_desktop/providers/vrsta_restorana_provider.dart';
import 'package:provider/provider.dart';

class AdminUrediDodajVrstuRestoranaScreen extends StatefulWidget {
  VrstaRestorana? odabranaVrstaRestorana;

  @override
  AdminUrediDodajVrstuRestoranaScreen({super.key, this.odabranaVrstaRestorana});

  State<AdminUrediDodajVrstuRestoranaScreen> createState() =>
      _AdminUrediDodajVrstuRestoranaScreenState();
}

class _AdminUrediDodajVrstuRestoranaScreenState
    extends State<AdminUrediDodajVrstuRestoranaScreen> {
  late VrstaRestoranaProvider vrstaRestoranaProvider;

  SearchResult<VrstaRestorana>? vrstaRestoranaResult;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  String? nazivError;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'naziv': widget.odabranaVrstaRestorana?.naziv,
    };
    vrstaRestoranaProvider = context.read<VrstaRestoranaProvider>();

    _initForm();
  }

  Future _initForm() async {
    vrstaRestoranaResult = await vrstaRestoranaProvider.get();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Uređivanje vrste restorana",
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
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'naziv',
                        decoration: InputDecoration(
                          labelText: 'Naziv vrste restorana',
                          hintText: 'Naziv vrste restorana',
                          errorText: nazivError,
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
                          FormBuilderValidators.match(
                            r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ\s]*$',
                            errorText:
                                "Naziv mora početi velikim slovom i sadržavati samo slova.",
                          ),
                          FormBuilderValidators.required(
                            errorText: "Obavezno polje.",
                          ),
                          FormBuilderValidators.minLength(
                            2,
                            errorText: "Minimalna dužina je 2 znaka.",
                          ),
                        ]),
                        onChanged: (value) async {
                          if (value != null &&
                              vrstaRestoranaResult != null &&
                              vrstaRestoranaResult!.result != null) {
                            if (widget.odabranaVrstaRestorana == null) {
                              var nazivPostoji = vrstaRestoranaResult!.result!
                                  .any((e) =>
                                      (e.naziv?.toLowerCase() ?? '') ==
                                      value.toLowerCase());

                              if (nazivPostoji) {
                                nazivError =
                                    "Vrsta restorana sa tim imenom već postoji.";
                              } else {
                                nazivError = null;
                              }
                            } else {
                              var nazivPostoji = vrstaRestoranaResult!.result!
                                  .any((e) =>
                                      (e.naziv?.toLowerCase() ?? '') ==
                                          value.toLowerCase() &&
                                      e.vrstaId !=
                                          widget
                                              .odabranaVrstaRestorana?.vrstaId);

                              if (nazivPostoji) {
                                nazivError =
                                    "Vrsta restorana sa tim imenom već postoji.";
                              } else {
                                nazivError = null;
                              }
                            }

                            setState(() {});
                          }
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
                if (widget.odabranaVrstaRestorana == null) {
                  await vrstaRestoranaProvider.insert(req);
                } else {
                  await vrstaRestoranaProvider.update(
                      widget.odabranaVrstaRestorana!.vrstaId!, req);
                }
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Vrsta uspješno dodana/uređena."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text("U redu"),
                      ),
                    ],
                  ),
                );
                Navigator.pop(context, true);
                clearinput();
                if (mounted) setState(() {});
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
    nazivError = null;
  }
}
