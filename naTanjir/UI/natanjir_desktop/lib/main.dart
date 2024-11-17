import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cart/cart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:natanjir_desktop/layouts/master_screen.dart';
import 'package:natanjir_desktop/models/ocjena_proizvod.dart';
import 'package:natanjir_desktop/models/uloga.dart';
import 'package:natanjir_desktop/providers/auth_provider.dart';
import 'package:natanjir_desktop/providers/korisnici_provider.dart';
import 'package:natanjir_desktop/providers/narudzba_provider.dart';
import 'package:natanjir_desktop/providers/ocjena_proizvod_provider.dart';
import 'package:natanjir_desktop/providers/ocjena_restoran_provider.dart';
import 'package:natanjir_desktop/providers/product_provider.dart';
import 'package:natanjir_desktop/providers/restoran_favorit_provider.dart';
import 'package:natanjir_desktop/providers/restoran_provider.dart';
import 'package:natanjir_desktop/providers/signalr_provider.dart';
import 'package:natanjir_desktop/providers/stavke_narudzbe_provider.dart';
import 'package:natanjir_desktop/providers/uloga_provider.dart';
import 'package:natanjir_desktop/providers/vrsta_proizvodum_provider.dart';
import 'package:natanjir_desktop/providers/vrsta_restorana_provider.dart';
import 'package:natanjir_desktop/screens/admin_dashboard_screen.dart';
import 'package:natanjir_desktop/screens/product_list_screen.dart';
import 'package:natanjir_desktop/screens/radnik_narudzbe_list_screen.dart';
import 'package:natanjir_desktop/screens/vlasnik_dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => VrstaProizvodumProvider()),
    ChangeNotifierProvider(create: (_) => RestoranProvider()),
    ChangeNotifierProvider(create: (_) => KorisniciProvider()),
    ChangeNotifierProvider(create: (_) => VrstaRestoranaProvider()),
    ChangeNotifierProvider(create: (_) => OcjenaRestoranProvider()),
    ChangeNotifierProvider(create: (_) => RestoranFavoritProvider()),
    ChangeNotifierProvider(create: (_) => OcjenaProizvodProvider()),
    ChangeNotifierProvider(create: (_) => NarudzbaProvider()),
    ChangeNotifierProvider(create: (_) => StavkeNarudzbeProvider()),
    ChangeNotifierProvider(create: (_) => UlogeProvider()),
    ChangeNotifierProvider(create: (_) => SignalRProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.blue, primary: Colors.green),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHidden = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  final SignalRProvider _signalRProvider = SignalRProvider();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (AuthProvider.isSignedIn) {
      _signalRProvider.stopConnection();
      AuthProvider.connectionId = null;
      AuthProvider.isSignedIn = false;
    }
    _signalRProvider.startConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(100, 0, 83, 86),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                      height: 190,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/naTanjirLogo.png"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 99, 71),
                                    fontSize: 13),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.account_circle_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "Korisničko ime",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 158, 158, 158),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Molimo da unesete korisničko ime.";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _isHidden,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 99, 71),
                                    fontSize: 13),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: GestureDetector(
                                  onTap: () => {
                                    setState(() {
                                      _isHidden = !_isHidden;
                                    })
                                  },
                                  child: Icon(_isHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "Lozinka",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 158, 158, 158),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Molimo da unesete lozinku.";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(97, 158, 158, 158),
                        ),
                        child: InkWell(
                          onTap: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              var provider = KorisniciProvider();
                              AuthProvider.username = _usernameController.text;
                              AuthProvider.password = _passwordController.text;
                            }

                            try {
                              KorisniciProvider korisniciProvider =
                                  new KorisniciProvider();

                              var korisnik = await korisniciProvider.login(
                                  AuthProvider.username!,
                                  AuthProvider.password!,
                                  AuthProvider.connectionId!);

                              if (korisnik.isDeleted!) {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: 'Račun deaktiviran',
                                  text: 'Vaš korisnički račun je deaktiviran!',
                                );
                                return;
                              }

                              AuthProvider.korisnikId = korisnik.korisnikId;
                              AuthProvider.ime = korisnik.ime;
                              AuthProvider.prezime = korisnik.prezime;
                              AuthProvider.email = korisnik.email;
                              AuthProvider.telefon = korisnik.telefon;
                              AuthProvider.datumRodjenja =
                                  korisnik.datumRodjenja;
                              AuthProvider.slika = korisnik.slika;
                              AuthProvider.isSignedIn = true;

                              if (korisnik.korisniciUloges != null) {
                                AuthProvider.korisnikUloge =
                                    korisnik.korisniciUloges;
                              }
                              if (korisnik.restoranId != null) {
                                AuthProvider.restoranId = korisnik.restoranId;
                              }
                              print("Authenticated!");

                              if (AuthProvider.korisnikUloge != null &&
                                  AuthProvider.korisnikUloge!
                                      .any((x) => x.uloga?.naziv == "Admin")) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AdminDashboardScreen(),
                                ));
                              } else if (AuthProvider.korisnikUloge != null &&
                                  AuthProvider.korisnikUloge!.any(
                                      (x) => x.uloga?.naziv == "Vlasnik")) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      VlasnikDashboardScreen(),
                                ));
                              } else if (AuthProvider.korisnikUloge != null &&
                                  AuthProvider.korisnikUloge!.any((x) =>
                                      x.uloga?.naziv == "RadnikRestorana")) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      RadnikNarudzbeListScreen(),
                                ));
                              }
                            } on Exception catch (e) {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: e.toString(),
                              );
                            }
                          },
                          child: Center(
                            child: Text(
                              "Prijavi se",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 150,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  child: SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Image.asset(
                                      "assets/images/firstImg.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 100,
                                  child: SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Image.asset(
                                      "assets/images/secondImg.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
