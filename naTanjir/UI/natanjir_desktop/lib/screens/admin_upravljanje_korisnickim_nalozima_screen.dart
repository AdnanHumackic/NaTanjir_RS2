import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/korisnici.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/uloga.dart';
import 'package:natanjir_desktop/providers/korisnici_provider.dart';
import 'package:natanjir_desktop/providers/uloga_provider.dart';
import 'package:natanjir_desktop/providers/utils.dart';
import 'package:natanjir_desktop/screens/admin_uredi_korisnicki_profil.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AdminUpravljanjeKorisnickimNalozimaScreen extends StatefulWidget {
  @override
  _AdminUpravljanjeKorisnickimNalozimaScreenState createState() =>
      _AdminUpravljanjeKorisnickimNalozimaScreenState();
}

class _AdminUpravljanjeKorisnickimNalozimaScreenState
    extends State<AdminUpravljanjeKorisnickimNalozimaScreen>
    with SingleTickerProviderStateMixin {
  late UlogeProvider ulogeProvider;
  late KorisniciProvider korisniciProvider;

  SearchResult<Uloga>? ulogeResult;

  late KorisniciDataSource _source;
  int page = 1;
  int pageSize = 10;
  int count = 10;
  bool _isLoading = false;

  @override
  BuildContext get context => super.context;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ulogeProvider = context.read<UlogeProvider>();
    korisniciProvider = context.read<KorisniciProvider>();
    _source = KorisniciDataSource(
        provider: korisniciProvider,
        context: context,
        imePrezime: _imePrezimeGTEController.text,
        korisnickoIme: _korisnickoImeController.text,
        email: _emailController.text,
        uloga: selectedItem,
        isDeleted: isDeleted);

    _initForm();
  }

  Future _initForm() async {
    ulogeResult = await ulogeProvider.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Dashboard",
      Column(
        children: [_buildSearch(), _buildPage()],
      ),
    );
  }

  String? selectedItem;
  TextEditingController _imePrezimeGTEController = new TextEditingController();
  TextEditingController _korisnickoImeController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  bool? isDeleted;

  Widget _buildSearch() {
    return Padding(
      padding: EdgeInsets.all(25),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _imePrezimeGTEController,
                  decoration: InputDecoration(
                    labelText: 'Ime i prezime korisnika',
                    hintText: 'Ime i prezime korisnika',
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
                    _source.imePrezime = _imePrezimeGTEController.text;
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
                child: DropdownButtonFormField<String>(
                  value: selectedItem,
                  decoration: InputDecoration(
                    labelText: 'Uloga korisnika',
                    hintText: 'Uloga korisnika',
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
                  items: ulogeResult?.result.map((Uloga uloga) {
                        return DropdownMenuItem<String>(
                          value: uloga.naziv,
                          child: Text(uloga.naziv!),
                        );
                      }).toList() ??
                      [],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedItem = newValue;
                      _source.uloga = newValue.toString();
                      _source.filterServerSide();
                      setState(() {});
                    });
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
                child: TextField(
                  controller: _korisnickoImeController,
                  decoration: InputDecoration(
                    labelText: 'Korisničko ime',
                    hintText: 'Korisničko ime',
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
                    _source.korisnickoIme = _korisnickoImeController.text;
                    _source.filterServerSide();
                    setState(() {});
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email korisnika',
                    hintText: 'Email korisnika',
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
                    _source.email = _emailController.text;
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
                    color: Color.fromARGB(97, 158, 158, 158),
                  ),
                  child: InkWell(
                    onTap: () async {
                      _imePrezimeGTEController.clear();
                      _korisnickoImeController.clear();
                      _emailController.clear();

                      setState(() {
                        selectedItem = null;
                        isDeleted = null;
                      });
                      _source.imePrezime = '';
                      _source.isDeleted = null;
                      _source.korisnickoIme = '';
                      _source.email = '';
                      _source.uloga = '';
                      _source.filterServerSide();
                      setState(() {});
                    },
                    child: Center(
                      child: Text(
                        "Očisti filtere",
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
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPage() {
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: AdvancedPaginatedDataTable(
                  columns: const [
                    DataColumn(label: Text("Ime")),
                    DataColumn(label: Text("Prezime")),
                    DataColumn(label: Text("Korisničko ime")),
                    DataColumn(label: Text("Email")),
                    DataColumn(label: Text("Telefon")),
                    DataColumn(label: Text("Datum rođenja")),
                    DataColumn(label: Text("Obrisan")),
                    DataColumn(label: Text("Aktivacija/Deaktivacija")),
                  ],
                  source: _source,
                  addEmptyRows: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KorisniciDataSource extends AdvancedDataTableSource<Korisnici> {
  List<Korisnici>? data = [];
  final KorisniciProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String imePrezime = "";
  String korisnickoIme = "";
  String email = "";
  String uloga = "";
  bool? isDeleted;
  dynamic filter;
  BuildContext context;
  KorisniciDataSource(
      {required this.provider,
      required this.context,
      required String imePrezime,
      required String korisnickoIme,
      required String email,
      String? uloga,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminUrediKorisnickiProfilScreen(
                              odabraniKorisnik: item,
                            )),
                  ).then((value) {
                    if (value == true) {
                      filterServerSide();
                    }
                  })
                }
            },
        cells: [
          DataCell(Text(
            item!.ime.toString(),
            style: TextStyle(fontSize: 15),
          )),
          DataCell(Text(
            item.prezime.toString(),
            style: TextStyle(fontSize: 15),
          )),
          DataCell(Text(item.korisnickoIme.toString(),
              style: TextStyle(fontSize: 15))),
          DataCell(Text(item.email.toString(), style: TextStyle(fontSize: 15))),
          DataCell(
              Text(item.telefon.toString(), style: TextStyle(fontSize: 15))),
          DataCell(Text(formatDate(item.datumRodjenja.toString()),
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
                  try {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title: "Da li ste sigurni da želite obrisati korisnika?",
                      text:
                          "Ovo će obrisati korisnika i onemoguiti mu pristup aplikaciji.",
                      confirmBtnText: "Da",
                      cancelBtnText: "Ne",
                      onConfirmBtnTap: () async {
                        Navigator.of(context).pop();
                        await provider.delete(item.korisnikId!);

                        await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: "Korisnik uspješno obrisan!",
                        );
                        filterServerSide();

                        //Navigator.of(context).pop();
                      },
                    );
                  } on Exception catch (e) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: "Greška prilikom brisanja korisnika!",
                    );
                  }
                },
                child: Container(
                  child: Text(
                    "Obriši",
                    style: TextStyle(fontSize: 15, color: Colors.red),
                  ),
                ),
              ),
            ),
          if (item.isDeleted == true)
            DataCell(
              TextButton(
                onPressed: () async {
                  try {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title:
                          "Da li ste sigurni da želite aktivirati korisnikov račun?",
                      text: "Ovo će omogućiti korisniku pristup aplikaciji.",
                      confirmBtnText: "Da",
                      cancelBtnText: "Ne",
                      onConfirmBtnTap: () async {
                        var upd = {
                          'ime': item.ime,
                          'prezime': item.prezime,
                          'telefon': item.telefon,
                          'slika': item.slika,
                          'isDeleted': false,
                          'vrijemeBrisanja': null,
                          'korisnickoIme': item.korisnickoIme,
                          'email': item.email,
                        };
                        await provider.update(item.korisnikId!, upd);
                        Navigator.of(context).pop();

                        await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: "Korisnikov račun uspješno aktiviran!",
                        );
                        filterServerSide();
                      },
                    );
                  } on Exception catch (e) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: "Greška prilikom aktiviranja korisničkog računa!",
                    );
                  }
                },
                child: Container(
                  child: Text(
                    "Aktiviraj račun",
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
  Future<RemoteDataSourceDetails<Korisnici>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'imePrezimeGTE': imePrezime,
      'korisnickoIme': korisnickoIme,
      'emailGTE': email,
      'uloga': uloga,
      'isDeleted': isDeleted
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
