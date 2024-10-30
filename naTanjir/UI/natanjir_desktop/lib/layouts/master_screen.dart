import 'package:flutter/material.dart';
import 'package:natanjir_desktop/main.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:natanjir_desktop/screens/admin_dashboard_screen.dart';
import 'package:natanjir_desktop/screens/admin_upravljanje_korisnickim_nalozima_screen.dart';
import 'package:natanjir_desktop/screens/admin_upravljanje_restoranima_screen.dart';
import 'package:natanjir_desktop/screens/korisnik_profile_screen.dart';
import 'package:natanjir_desktop/screens/vlasnik_dashboard_screen.dart';
import 'package:natanjir_desktop/screens/vlasnik_upravljanje_menijem_screen.dart';

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
      body: Row(
        children: [
          Container(
              width: 300,
              color: Color.fromARGB(255, 0, 83, 86),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Image.asset("assets/images/naTanjirLogo.png",
                                      width: 150),
                                ],
                              ),
                            ),
                            if (AuthProvider.korisnikUloge != null &&
                                AuthProvider.korisnikUloge!
                                    .any((x) => x.uloga?.naziv == "Admin"))
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  "Admin panel",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            if (AuthProvider.korisnikUloge != null &&
                                AuthProvider.korisnikUloge!
                                    .any((x) => x.uloga?.naziv == "Vlasnik"))
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  "Vlasnik panel",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Divider(),
                            ),
                            if (AuthProvider.korisnikUloge != null &&
                                AuthProvider.korisnikUloge!
                                    .any((x) => x.uloga?.naziv == "Admin"))
                              ListTile(
                                leading: const Icon(
                                  Icons.home_outlined,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "Dashboard",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          AdminDashboardScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge != null &&
                                AuthProvider.korisnikUloge!
                                    .any((x) => x.uloga?.naziv == "Vlasnik"))
                              ListTile(
                                leading: const Icon(
                                  Icons.home_outlined,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "Dashboard",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          VlasnikDashboardScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge != null &&
                                AuthProvider.korisnikUloge!
                                    .any((x) => x.uloga?.naziv == "Vlasnik"))
                              ListTile(
                                leading: const Icon(
                                  Icons.menu_book_outlined,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "Upravljanje menijem",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          VlasnikUpravljanjeMenijemScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge != null &&
                                AuthProvider.korisnikUloge!
                                    .any((x) => x.uloga?.naziv == "Vlasnik"))
                              ListTile(
                                leading: const Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "Upravljanje zaposlenicima",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          VlasnikUpravljanjeMenijemScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge != null &&
                                AuthProvider.korisnikUloge!
                                    .any((x) => x.uloga?.naziv == "Vlasnik"))
                              ListTile(
                                leading: const Icon(
                                  Icons.restaurant_outlined,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "Upravljanje restoranom",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          VlasnikUpravljanjeMenijemScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge != null &&
                                AuthProvider.korisnikUloge!
                                    .any((x) => x.uloga?.naziv == "Admin"))
                              ListTile(
                                leading: const Icon(
                                  Icons.restaurant_outlined,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "Upravljanje restoranima",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          AdminUpravljanjeRestoranimaScreen()));
                                },
                              ),
                            if (AuthProvider.korisnikUloge != null &&
                                AuthProvider.korisnikUloge!
                                    .any((x) => x.uloga?.naziv == "Admin"))
                              ListTile(
                                leading: const Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                ),
                                title: const Text(
                                  "Upravljanje korisničkim nalozima",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          AdminUpravljanjeKorisnickimNalozimaScreen()));
                                },
                              ),
                            Spacer(),
                            ListTile(
                              leading: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              title: const Text(
                                "Nazad",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Divider(),
                            ),
                            ListTile(
                              leading: const Icon(Icons.edit_outlined,
                                  color: Colors.white),
                              title: const Text(
                                "Uredi profil",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        KorisnikProfileScreen()));
                              },
                            ),
                            ListTile(
                              leading:
                                  const Icon(Icons.logout, color: Colors.white),
                              title: const Text(
                                "Odjavi se",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              onTap: () {
                                AuthProvider.datumRodjenja?.isEmpty;
                                AuthProvider.email = null;
                                AuthProvider.ime = null;
                                AuthProvider.korisnikId = null;
                                AuthProvider.prezime = null;
                                AuthProvider.slika = null;
                                AuthProvider.telefon = null;
                                AuthProvider.username = null;
                                AuthProvider.password = null;
                                AuthProvider.korisnikUloge = null;
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => MyApp()));

                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
