import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/ocjena_restoran.dart';
import 'package:natanjir_desktop/models/proizvod.dart';
import 'package:natanjir_desktop/models/restoran.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/vrsta_restorana.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:natanjir_desktop/providers/ocjena_restoran_provider.dart';
import 'package:natanjir_desktop/providers/restoran_provider.dart';
import 'package:natanjir_desktop/providers/vrsta_restorana_provider.dart';
import 'package:natanjir_desktop/screens/admin_upravljanje_restoranima_screen.dart';
import 'package:natanjir_desktop/screens/restoran_details_screen.dart';
import 'package:natanjir_desktop/screens/vlasnik_uredi_restoran_screen.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class VlasnikUpravljanjeRestoranomScreen extends StatefulWidget {
  const VlasnikUpravljanjeRestoranomScreen({super.key});

  @override
  State<VlasnikUpravljanjeRestoranomScreen> createState() =>
      _VlasnikUpravljanjeRestoranomScreenState();
}

class _VlasnikUpravljanjeRestoranomScreenState
    extends State<VlasnikUpravljanjeRestoranomScreen>
    with SingleTickerProviderStateMixin {
  late RestoranProvider restoranProvider;
  late VrstaRestoranaProvider vrstaRestoranaProvider;
  late OcjenaRestoranProvider ocjenaRestoranProvider;

  SearchResult<Restoran>? restoranResult;
  SearchResult<VrstaRestorana>? vrstaRestoranaResult;
  SearchResult<OcjenaRestoran>? ocjenaRestoranResult;

  late RestoraniDataSource _source;
  int page = 1;
  int pageSize = 10;
  int count = 10;
  @override
  BuildContext get context => super.context;

  @override
  void initState() {
    super.initState();
    restoranProvider = context.read<RestoranProvider>();
    vrstaRestoranaProvider = context.read<VrstaRestoranaProvider>();
    ocjenaRestoranProvider = context.read<OcjenaRestoranProvider>();

    _source = RestoraniDataSource(
        provider: RestoranProvider(),
        context: context,
        nazivRestorana: _nazivRestoranaController.text,
        vrstaRestorana: selectedVrsta,
        vlasnikRestorana: AuthProvider.korisnikId,
        isDeleted: isDeleted);
    _initForm();
  }

  Future _initForm() async {
    vrstaRestoranaResult = await vrstaRestoranaProvider.get();
    ocjenaRestoranResult = await ocjenaRestoranProvider.get();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Vlasnik upravljanje restoranom",
      Column(
        children: [_buildSearch(), _buildPage()],
      ),
    );
  }

  TextEditingController _nazivRestoranaController = TextEditingController();
  String? selectedVrsta;
  bool? isDeleted;

  Widget _buildSearch() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nazivRestoranaController,
                    decoration: InputDecoration(
                      labelText: 'Naziv restorana',
                      hintText: 'Naziv restorana',
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
                      _source.nazivRestorana = _nazivRestoranaController.text;
                      _source.filterServerSide();
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedVrsta,
                    decoration: InputDecoration(
                      hintText: 'Vrsta restorana',
                      labelText: 'Vrsta restorana',
                      labelStyle: TextStyle(
                        color: Colors.black,
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
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text('---'),
                      ),
                      ...?vrstaRestoranaResult?.result
                          .map((VrstaRestorana vrstaRestorana) {
                        return DropdownMenuItem<String>(
                          value: vrstaRestorana.naziv,
                          child: Text(vrstaRestorana.naziv!),
                        );
                      }),
                    ],
                    onChanged: (String? newValue) {
                      selectedVrsta = newValue;
                      _source.vrstaRestorana = newValue ?? '';
                      _source.filterServerSide();
                      setState(() {});
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
                SizedBox(width: 15),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 0, 83, 86),
                    ),
                    child: InkWell(
                      onTap: () async {
                        _nazivRestoranaController.clear();

                        setState(() {
                          selectedVrsta = null;
                          isDeleted = null;
                        });
                        _source.nazivRestorana = '';
                        _source.isDeleted = null;
                        _source.vrstaRestorana = '';
                        _source.filterServerSide();
                        setState(() {});
                      },
                      child: Center(
                        child: Text(
                          "Očisti filter",
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage() {
    return Flexible(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: AdvancedPaginatedDataTable(
                  columns: const [
                    DataColumn(label: Text("Naziv")),
                    DataColumn(label: Text("Lokacija")),
                    DataColumn(label: Text("Radno vrijeme OD")),
                    DataColumn(label: Text("Radno vrijeme DO")),
                    DataColumn(label: Text("Vrsta restorana")),
                    DataColumn(label: Text("Obrisan")),
                    DataColumn(label: Text("Obriši/Vrati u ponudu")),
                    DataColumn(label: Text("Uredi restoran")),
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

class RestoraniDataSource extends AdvancedDataTableSource<Restoran> {
  List<Restoran>? data = [];
  final RestoranProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String nazivRestorana = "";
  String? vrstaRestorana = "";
  int? vlasnikRestorana;
  bool? isDeleted;

  dynamic filter;
  BuildContext context;
  RestoraniDataSource(
      {required this.provider,
      required this.context,
      this.vrstaRestorana,
      required this.isDeleted,
      required this.nazivRestorana,
      required this.vlasnikRestorana});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(
      onSelectChanged: (selected) {
        if (selected == true) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RestoranDetailsScreen(
                    odabraniRestoran: item,
                    avgOcjena: "",
                  )));
        }
      },
      cells: [
        DataCell(Text(item?.naziv ?? '', style: TextStyle(fontSize: 15))),
        DataCell(Text(item?.lokacija ?? '', style: TextStyle(fontSize: 15))),
        DataCell(Text(item?.radnoVrijemeOd?.toString() ?? '',
            style: TextStyle(fontSize: 15))),
        DataCell(Text(item?.radnoVrijemeDo?.toString() ?? '',
            style: TextStyle(fontSize: 15))),
        DataCell(Text(item?.vrstaRestorana?.naziv.toString() ?? '',
            style: TextStyle(fontSize: 15))),
        DataCell(
          Text(
            item?.isDeleted == true ? 'Da' : 'Ne',
            style: TextStyle(fontSize: 15),
          ),
        ),
        if (item?.isDeleted == false)
          DataCell(
            TextButton(
              onPressed: () async {
                try {
                  await QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    title: "Da li ste sigurni da želite obrisati restoran?",
                    text:
                        "Ovo će obrisati restoran kao i sve njegove proizvode iz ponude.",
                    confirmBtnText: "Da",
                    cancelBtnText: "Ne",
                    onConfirmBtnTap: () async {
                      try {
                        Navigator.of(context).pop();

                        await provider.delete(item!.restoranId!);

                        await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: "Restoran uspješno obrisan!",
                        );

                        // Refresh data
                        filterServerSide();
                      } catch (e) {
                        Navigator.of(context).pop();

                        await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Greška prilikom brisanja restorana!",
                        );
                      }
                    },
                  );
                } on Exception catch (e) {
                  await QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: "Greška!",
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
        if (item?.isDeleted == true)
          DataCell(
            TextButton(
              onPressed: () async {
                try {
                  await QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    title:
                        "Da li ste sigurni da želite vratiti restoran u ponudu?",
                    text:
                        "Ovo će vratiti restoran u ponudu kao i sve njegove proizvode iz ponude.",
                    confirmBtnText: "Da",
                    cancelBtnText: "Ne",
                    onConfirmBtnTap: () async {
                      try {
                        var upd = {
                          'radnoVrijemeOd': item?.radnoVrijemeOd,
                          'radnoVrijemeDo': item?.radnoVrijemeDo,
                          'slika': item?.slika,
                          'lokacija': item?.lokacija,
                          'isDeleted': false,
                          'vrijemeBrisanja': null,
                        };

                        await provider.update(item!.restoranId!, upd);

                        Navigator.of(context).pop();

                        await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: "Restoran uspješno vraćen u ponudu!",
                        );

                        filterServerSide();
                      } catch (e) {
                        Navigator.of(context).pop();

                        await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Greška prilikom vraćanja restorana u ponudu!",
                        );
                      }
                    },
                  );
                } on Exception catch (e) {
                  await QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: "Greška!",
                  );
                }
              },
              child: Container(
                child: Text(
                  "Vrati u ponudu",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 0, 83, 86),
                  ),
                ),
              ),
            ),
          ),
        DataCell(
          TextButton(
            onPressed: () async {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) =>
                          VlasnikUrediRestoranScreen(odabraniRestoran: item)))
                  .then((value) {
                if (value == true) {
                  filterServerSide();
                }
              });
            },
            child: Container(
              child: Text(
                "Uredi restoran",
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 0, 83, 86),
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
  Future<RemoteDataSourceDetails<Restoran>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'nazivGTE': nazivRestorana,
      'vlasnikRestoranaId': vlasnikRestorana,
      'vrstaRestoranaNazivGTE': vrstaRestorana,
      'vlasnikId': vlasnikRestorana,
      'isDeleted': isDeleted,
      'isVrstaRestoranaIncluded': true
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
