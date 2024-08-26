import 'package:flutter/material.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Lista proizvoda",
        Column(
          children: [
            Text("Lista proizvoda placeholder"),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Nazad"))
          ],
        ));
  }
}
