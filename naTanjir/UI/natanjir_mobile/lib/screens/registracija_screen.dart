import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:natanjir_mobile/models/korisnici.dart';
import 'package:natanjir_mobile/models/search_result.dart';
import 'package:natanjir_mobile/providers/korisnici_provider.dart';
import 'package:natanjir_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class RegistracijaScreen extends StatefulWidget {
  RegistracijaScreen({super.key});

  @override
  State<RegistracijaScreen> createState() => _RegistracijaScreenState();
}

class _RegistracijaScreenState extends State<RegistracijaScreen> {
  late KorisniciProvider korisniciProvider;

  SearchResult<Korisnici>? korisniciResult;

  final _formKey = GlobalKey<FormBuilderState>();

  String? confirmPasswordError;
  String? usernameError;
  String? dateError;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    korisniciProvider = context.read<KorisniciProvider>();

    _initForm();
  }

  Future _initForm() async {
    korisniciResult = await korisniciProvider.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 83, 86),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 83, 86),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [_buildForm(), _saveRow()],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              child: Image.asset("assets/images/registrujSe.png"),
            ),
            SizedBox(height: 15),
            FormBuilderTextField(
              decoration: InputDecoration(
                errorStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 99, 71), fontSize: 14),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                hintText: "Ime",
                prefixIcon: Icon(Icons.account_circle_outlined),
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
                FormBuilderValidators.match(r'^[A-Z][a-zA-Z]*$',
                    errorText:
                        "Ime mora počinjati sa velikim slovom i smije \nsadržavati samo slova.")
              ]),
            ),
            SizedBox(height: 15),
            FormBuilderTextField(
              decoration: InputDecoration(
                errorStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 99, 71), fontSize: 14),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
                hintText: "Prezime",
                prefixIcon: Icon(Icons.account_circle_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              name: 'prezime',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Obavezno polje."),
                FormBuilderValidators.minLength(2,
                    errorText: "Minimalna dužina prezimena je 2 znaka."),
                FormBuilderValidators.maxLength(40,
                    errorText: "Maksimalna dužina prezimena je 40 znakova."),
                FormBuilderValidators.match(r'^[A-Z][a-zA-Z]*$',
                    errorText:
                        "Prezime mora počinjati sa velikim slovom i smije \nsadržavati samo slova.")
              ]),
            ),
            SizedBox(height: 15),
            FormBuilderTextField(
              decoration: InputDecoration(
                errorStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 99, 71), fontSize: 14),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              name: 'email',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Obavezno polje."),
                FormBuilderValidators.email(errorText: "Email nije validan.")
              ]),
            ),
            SizedBox(height: 15),
            FormBuilderTextField(
              decoration: InputDecoration(
                errorStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 99, 71), fontSize: 14),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                hintText: "Broj telefona",
                prefixIcon: Icon(Icons.phone),
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
            FormBuilderDateTimePicker(
              decoration: InputDecoration(
                errorText: dateError,
                errorStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 99, 71), fontSize: 14),
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
                FormBuilderValidators.required(errorText: "Obavezno polje."),
              ]),
              onChanged: (value) async {
                if (value != null) {
                  DateTime date = DateTime.now();
                  int age = date.year - value.year;

                  if (age < 18 || value!.isAfter(DateTime.now())) {
                    dateError =
                        "Morate biti stariji od 18 godina i\ndatum rođenja ne smije biti stariji od \ndanašnjeg.";
                  }
                } else {
                  dateError = null;
                }

                setState(() {});
              },
            ),
            SizedBox(height: 15),
            FormBuilderTextField(
              decoration: InputDecoration(
                errorText: usernameError,
                errorStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 99, 71), fontSize: 14),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                hintText: "Korisničko ime",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              name: 'korisnickoIme',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Obavezno polje."),
              ]),
              onChanged: (value) async {
                if (value != null) {
                  var username = await korisniciResult!.result
                      .map((e) => e.korisnickoIme == value)
                      .toList();
                  if (username.contains(true)) {
                    usernameError = "Korisnik s tim imenom već postoji.";
                  } else {
                    usernameError = null;
                  }
                }
                setState(() {});
              },
            ),
            SizedBox(height: 15),
            FormBuilderTextField(
              decoration: InputDecoration(
                errorStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 99, 71), fontSize: 14),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                hintText: "Lozinka",
                prefixIcon: Icon(Icons.password),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              name: 'lozinka',
              obscureText: true,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Obavezno polje."),
              ]),
            ),
            SizedBox(height: 15),
            FormBuilderTextField(
              decoration: InputDecoration(
                errorStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 99, 71), fontSize: 14),
                errorText: confirmPasswordError,
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(Icons.password),
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
                FormBuilderValidators.required(errorText: "Obavezno polje."),
              ]),
              onChanged: (value) {
                if (value != null &&
                    _formKey.currentState!.fields['lozinka']?.value != value) {
                  confirmPasswordError =
                      "Lozinka potvrda se mora podudarati sa \nunesenom lozinkom.";
                } else {
                  confirmPasswordError = null;
                }
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _saveRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(97, 158, 158, 158),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fixedSize: Size(double.infinity, 40),
              ),
              onPressed: () async {
                var isValid = _formKey.currentState!.saveAndValidate();
                if (isValid == true) {
                  var req = Map.from(_formKey.currentState!.value);
                  DateTime dob = req['datumRodjenja'];
                  req['datumRodjenja'] = dob.toIso8601String().split('T')[0];
                  req['uloge'] = [1];
                  await korisniciProvider.insert(req);
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    title: "Registracija uspješna!",
                  );

                  setState(() {
                    resetFields();
                  });
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: "Greška prilikom registracije.",
                  );
                }
              },
              child: Text(
                "Registruj se",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void resetFields() {
    _formKey.currentState?.reset();
    usernameError = null;
    dateError = null;
    confirmPasswordError = null;
  }
}
