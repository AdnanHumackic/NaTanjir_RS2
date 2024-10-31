import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/proizvod.dart';
import 'package:natanjir_desktop/models/restoran.dart';
import 'package:natanjir_desktop/models/search_result.dart';
import 'package:natanjir_desktop/models/vrsta_proizvodum.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:natanjir_desktop/providers/product_provider.dart';
import 'package:natanjir_desktop/providers/restoran_provider.dart';
import 'package:natanjir_desktop/providers/utils.dart';
import 'package:natanjir_desktop/providers/vrsta_proizvodum_provider.dart';
import 'package:natanjir_desktop/screens/vlasnik_dodaj_proizvod_screen.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class VlasnikUpravljanjeMenijemScreen extends StatefulWidget {
  const VlasnikUpravljanjeMenijemScreen({super.key});

  @override
  State<VlasnikUpravljanjeMenijemScreen> createState() =>
      _VlasnikUpravljanjeMenijemScreenState();
}

class _VlasnikUpravljanjeMenijemScreenState
    extends State<VlasnikUpravljanjeMenijemScreen>
    with SingleTickerProviderStateMixin {
  late RestoranProvider restoranProvider;
  late ProductProvider proizvodProvider;
  late VrstaProizvodumProvider vrstaProizvodumProvider;

  SearchResult<Restoran>? restoranResult;
  SearchResult<Proizvod>? proizvodResult;
  SearchResult<VrstaProizvodum>? vrstaProizvodumResult;

  late ProizvodiDataSource _source;
  int page = 1;
  int pageSize = 10;
  int count = 10;
  bool _isLoading = false;
  //dodaj ocjene za proizvode i za restoran
  @override
  BuildContext get context => super.context;

  @override
  void initState() {
    super.initState();
    restoranProvider = context.read<RestoranProvider>();
    proizvodProvider = context.read<ProductProvider>();
    vrstaProizvodumProvider = context.read<VrstaProizvodumProvider>();
    _source = ProizvodiDataSource(
        provider: ProductProvider(),
        context: context,
        nazivRestorana: selectedItem ?? "",
        nazivProizvoda: _nazivProizvodaController.text,
        vlasnikRestorana: AuthProvider.korisnikId,
        vrstaProizvoda: selectedVrsta,
        isDeleted: isDeleted);
    _initForm();
  }

  Future _initForm() async {
    restoranResult = await restoranProvider
        .get(filter: {'vlasnikId': AuthProvider.korisnikId});
    vrstaProizvodumResult = await vrstaProizvodumProvider.get();
    setState(() {});
  }

  String? selectedItem;
  String? selectedVrsta;
  bool? isDeleted;
  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Upravljanje menijem",
      Column(
        children: [_buildSearch(), _buildPage()],
      ),
    );
  }

  TextEditingController _nazivProizvodaController = TextEditingController();

  Widget _buildSearch() {
    return Padding(
      padding: EdgeInsets.all(25),
      child: Column(
        children: [
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nazivProizvodaController,
                  decoration: InputDecoration(
                    labelText: 'Naziv proizvoda',
                    hintText: 'Naziv proizvoda',
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
                    _source.nazivProizvoda = _nazivProizvodaController.text;
                    _source.filterServerSide();
                    setState(() {});
                  },
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedItem,
                  decoration: InputDecoration(
                    hintText: 'Naziv restorana',
                    labelText: 'Naziv restorana',
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
                    ...?restoranResult?.result
                        .where((element) =>
                            element.vlasnikId == AuthProvider.korisnikId)
                        .map((Restoran restoran) {
                      return DropdownMenuItem<String>(
                        value: restoran.naziv,
                        child: Text(restoran.naziv!),
                      );
                    }),
                  ],
                  onChanged: (String? newValue) {
                    selectedItem = newValue;
                    _source.nazivRestorana = newValue ?? '';
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
                child: DropdownButtonFormField<String>(
                  value: selectedVrsta,
                  decoration: InputDecoration(
                    hintText: 'Vrsta proizvoda',
                    labelText: 'Vrsta proizvoda',
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
                    ...?vrstaProizvodumResult?.result
                        .map((VrstaProizvodum vrsta) {
                      return DropdownMenuItem<String>(
                        value: vrsta.naziv,
                        child: Text(vrsta.naziv!),
                      );
                    }),
                  ],
                  onChanged: (String? newValue) {
                    selectedVrsta = newValue;
                    _source.vrstaProizvoda = newValue ?? '';
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
                      _nazivProizvodaController.clear();

                      setState(() {
                        selectedItem = null;
                        selectedVrsta = null;
                        isDeleted = null;
                      });
                      _source.nazivProizvoda = '';
                      _source.nazivRestorana = '';
                      _source.isDeleted = null;
                      _source.vrstaProizvoda = '';
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
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Spacer(),
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
                                  VlasnikDodajProizvodScreen()))
                          .then(
                        (value) {
                          if (value == true) _source.filterServerSide();
                        },
                      );
                    },
                    child: Center(
                      child: Text(
                        "Dodaj proizvod",
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
                    DataColumn(label: Text("Naziv")),
                    DataColumn(label: Text("Cijena")),
                    DataColumn(label: Text("Opis")),
                    DataColumn(label: Text("Vrsta proizvoda")),
                    DataColumn(label: Text("Restoran")),
                    DataColumn(label: Text("Obrisan")),
                    DataColumn(label: Text("Obriši/Vrati u ponudu")),
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

class ProizvodiDataSource extends AdvancedDataTableSource<Proizvod> {
  List<Proizvod>? data = [];
  final ProductProvider provider;
  int count = 10;
  int page = 1;
  int pageSize = 10;
  String nazivRestorana = "";
  String nazivProizvoda = "";
  int? vlasnikRestorana;
  String? vrstaProizvoda = "";
  bool? isDeleted;

  dynamic filter;
  BuildContext context;
  ProizvodiDataSource(
      {required this.provider,
      required this.context,
      required this.nazivRestorana,
      required this.nazivProizvoda,
      this.vlasnikRestorana,
      required this.vrstaProizvoda,
      required this.isDeleted});

  @override
  DataRow? getRow(int index) {
    if (index >= (count - ((page - 1) * pageSize))) {
      return null;
    }

    final item = data?[index];

    return DataRow(
      onSelectChanged: (selected) {
        if (selected == true) {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      VlasnikDodajProizvodScreen(proizvod: item)))
              .then((value) => {if (value == true) filterServerSide()});
        }
      },
      cells: [
        DataCell(Text(item?.naziv ?? '', style: TextStyle(fontSize: 15))),
        DataCell(Text("${formatNumber(item!.cijena)} KM",
            style: TextStyle(fontSize: 15))),
        DataCell(Text(item?.opis ?? '', style: TextStyle(fontSize: 15))),
        DataCell(Text(item?.vrstaProizvoda?.naziv.toString() ?? '',
            style: TextStyle(fontSize: 15))),
        DataCell(Text(item?.restoran?.naziv.toString() ?? '',
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
                    title:
                        "Da li ste sigurni da želite obrisati proizvod iz ponude?",
                    confirmBtnText: "Da",
                    cancelBtnText: "Ne",
                    onConfirmBtnTap: () async {
                      Navigator.of(context).pop();
                      await provider.delete(item!.proizvodId!);

                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: "Korisnik uspješno obrisan!",
                      );
                      filterServerSide();
                    },
                  );
                } on Exception catch (e) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: "Greška prilikom brisanja proizvoda!",
                  );
                }
              },
              child: Container(
                child: Text(
                  "Ukloni iz ponude",
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
                        "Da li ste sigurni da želite vratiti proizvod u ponudu?",
                    confirmBtnText: "Da",
                    cancelBtnText: "Ne",
                    onConfirmBtnTap: () async {
                      var upd = {
                        'naziv': item?.naziv,
                        'cijena': item?.cijena,
                        'opis': item?.opis,
                        'slika': item?.slika,
                        'isDeleted': false,
                        'vrijemeBrisanja': null,
                        'vrstaProizvodaId': item?.vrstaProizvodaId,
                      };
                      await provider.update(item!.proizvodId!, upd);
                      Navigator.of(context).pop();

                      await QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        title: "Proizvod uspješno vraćen u ponudu!",
                      );
                      filterServerSide();
                    },
                  );
                } on Exception catch (e) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: "Greška prilikom vraćanja proizvoda u ponudu!",
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
  Future<RemoteDataSourceDetails<Proizvod>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize).toInt() + 1;
    filter = {
      'nazivGTE': nazivProizvoda,
      'nazivRestoranaGTE': nazivRestorana,
      'vlasnikRestoranaId': vlasnikRestorana,
      'isVrstaIncluded': true,
      'isRestoranIncluded': true,
      'vrstaProizvodaNazivGTE': vrstaProizvoda,
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
