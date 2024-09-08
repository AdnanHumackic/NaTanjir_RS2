import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:natanjir_mobile/layouts/master_screen.dart';
import 'package:natanjir_mobile/models/proizvod.dart';
import 'package:natanjir_mobile/models/search_result.dart';
import 'package:natanjir_mobile/providers/product_provider.dart';
import 'package:natanjir_mobile/providers/utils.dart';
import 'package:natanjir_mobile/screens/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    provider = context.read<ProductProvider>();
  }

  SearchResult<Proizvod>? result = null;

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildSearch(), _buildResultView()]);
  }

  TextEditingController _nazivGteEditingController =
      new TextEditingController();
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      // child: Row(
      //   children: [
      //     Expanded(
      //         child: TextField(
      //       controller: _nazivGteEditingController,
      //       decoration: InputDecoration(labelText: "Naziv"),
      //     )),
      //     SizedBox(
      //       width: 8,
      //     ),
      //     Expanded(
      //         child: TextField(
      //       decoration: InputDecoration(labelText: "Drugi search parametar"),
      //     )),
      //     ElevatedButton(
      //         onPressed: () async {
      //           var filter = {
      //             'nazivGte': _nazivGteEditingController.text,
      //           };
      //           result = await provider.get(filter: filter);

      //           setState(() {});

      //           //TODO: add call to API
      //         },
      //         child: Text("Pretraga")),
      //     SizedBox(
      //       width: 8,
      //     ),
      //     ElevatedButton(
      //         onPressed: () async {
      //           //TODO: add call to API
      //           Navigator.of(context).pushReplacement(MaterialPageRoute(
      //               builder: (context) => ProductDetailsScreen()));
      //         },
      //         child: Text("Dodaj"))
      //   ],
      // ),
    );
  }

  Widget _buildResultView() {
    return Expanded(
        child: Container(
      width: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text("ID"), numeric: true),
            DataColumn(label: Text("Naziv")),
            DataColumn(label: Text("Vrsta proizvoda")),
            DataColumn(label: Text("Cijena")),
            DataColumn(label: Text("Slika")),
          ],
          rows: result?.result
                  .map((e) => DataRow(
                          onSelectChanged: (selected) => {
                                if (selected == true)
                                  {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsScreen(
                                                  proizvod: e,
                                                )))
                                  }
                              },
                          cells: [
                            DataCell(Text(e.proizvodId.toString())),
                            DataCell(Text(e.naziv ?? "")),
                            DataCell(Text(e.vrstaProizvodaId.toString())),
                            DataCell(Text(formatNumber(e.cijena))),
                            DataCell(e.slika != null
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    child: imageFromString(e.slika!),
                                  )
                                : Text("")),
                          ]))
                  .toList()
                  .cast<DataRow>() ??
              [], // Convert Iterable to List
        ),
      ),
    ));
  }
}
