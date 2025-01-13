import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/vrsta_proizvodum.dart';
import 'package:natanjir_desktop/models/vrsta_restorana.dart';
import 'package:natanjir_desktop/providers/vrsta_restorana_provider.dart';
import 'package:natanjir_desktop/screens/admin_uredi_dodaj_vrstu_restorana.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AdminUpravljanjeVrstamaRestoranaScreen extends StatefulWidget {
  const AdminUpravljanjeVrstamaRestoranaScreen({super.key});

  @override
  State<AdminUpravljanjeVrstamaRestoranaScreen> createState() =>
      _AdminUpravljanjeVrstamaRestoranaScreenState();
}

class _AdminUpravljanjeVrstamaRestoranaScreenState
    extends State<AdminUpravljanjeVrstamaRestoranaScreen>
    with SingleTickerProviderStateMixin {
  late VrstaRestoranaProvider vrstaRestoranaProvider;

  SearchResult<VrstaRestorana>? vrstaRestoranaResult;

  late VrstaRestoranaDataSource _source;
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
    vrstaRestoranaProvider = context.read<VrstaRestoranaProvider>();
    _source = VrstaRestoranaDataSource(
      provider: vrstaRestoranaProvider,
      context: context,
      nazivVrsteRestorana: _vrstaRestoranaNazivController.text,
    );

    _initForm();
  }

  Future _initForm() async {
    vrstaRestoranaResult = await vrstaRestoranaProvider.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Upravljanje vrstama restorana",
      Column(
        children: [_buildSearch(), _buildPage()],
      ),
    );
  }

  TextEditingController _vrstaRestoranaNazivController =
      new TextEditingController();

  Widget _buildSearch() {
    return Padding(
      padding: EdgeInsets.all(25),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _vrstaRestoranaNazivController,
                  decoration: InputDecoration(
                    labelText: 'Naziv vrste restorana',
                    hintText: 'Naziv vrste restorana',
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
                    _source.nazivVrsteRestorana =
                        _vrstaRestoranaNazivController.text;
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
                    color: Color.fromARGB(255, 0, 83, 86),
                  ),
                  child: InkWell(
                    onTap: () async {
                      _vrstaRestoranaNazivController.clear();

                      _source.nazivVrsteRestorana = '';

                      _source.filterServerSide();
                      setState(() {});
                    },
                    child: Center(
                      child: Text(
                        "Očisti filtere",
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
              SizedBox(
                height: 25,
              ),
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 0, 83, 86),
                  ),
                  child: InkWell(
                    onTap: () async {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) =>
                                  AdminUrediDodajVrstuRestoranaScreen()))
                          .then(
                        (value) {
                          if (value == true) _source.filterServerSide();
                        },
                      );
                    },
                    child: Center(
                      child: Text(
                        "Dodaj vrstu restorana",
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
                    DataColumn(label: Text("Naziv vrste restorana")),
                    DataColumn(label: Text("Obriši")),
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

class VrstaRestoranaDataSource extends AdvancedDataTableSource<VrstaRestorana> {
  List<VrstaRestorana>? data = [];
  final VrstaRestoranaProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String nazivVrsteRestorana = "";
  dynamic filter;
  BuildContext context;
  VrstaRestoranaDataSource({
    required this.provider,
    required this.context,
    required String nazivVrsteRestorana,
  });

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
                        builder: (context) =>
                            AdminUrediDodajVrstuRestoranaScreen(
                              odabranaVrstaRestorana: item,
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
            item!.naziv.toString(),
            style: TextStyle(fontSize: 15),
          )),
          DataCell(
            TextButton(
              onPressed: () async {
                try {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                          "Da li ste sigurni da želite obrisati vrstu restorana?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Ne"),
                        ),
                        TextButton(
                          onPressed: () async {
                            deleteVrsta(item.vrstaId!);
                            Navigator.pop(context);
                          },
                          child: Text("Da"),
                        ),
                      ],
                    ),
                  );
                } on Exception catch (e) {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Greška prilikom pokretanja akcije!"),
                      content: Text(e.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Container(
                child: Text(
                  "Obriši vrstu restorana",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ]);
  }

  Future<void> deleteVrsta(int id) async {
    try {
      await provider.delete(id);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Vrsta restorana uspješno obrisana."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                filterServerSide();
              },
              child: Text("U redu"),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Greška prilikom brisanja vrsta restorana!"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("U redu"),
            ),
          ],
        ),
      );
    }
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
  Future<RemoteDataSourceDetails<VrstaRestorana>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'nazivGTE': nazivVrsteRestorana,
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
