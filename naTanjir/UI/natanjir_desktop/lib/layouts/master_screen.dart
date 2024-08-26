import 'package:flutter/material.dart';
import 'package:natanjir_desktop/screens/product_list_screen.dart';
import 'package:natanjir_desktop/screens/user_list_screen.dart';

class MasterScreen extends StatefulWidget {
  MasterScreen(this.title, this.child, {super.key});
  String title;
  Widget child;

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        drawer: Drawer(
            child: ListView(
          children: [
            ListTile(
              title: Text("Back"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Korisnici"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserListScreen()));
              },
            ),
            ListTile(
              title: Text("Proizvodi"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProductListScreen()));
              },
            )
          ],
        )),
        body: widget.child);
  }
}
