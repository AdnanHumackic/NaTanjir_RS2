import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cart/cart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:natanjir_mobile/layouts/master_screen.dart';
import 'package:natanjir_mobile/models/ocjena_proizvod.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/cart_provider.dart';
import 'package:natanjir_mobile/providers/korisnici_provider.dart';
import 'package:natanjir_mobile/providers/narudzba_provider.dart';
import 'package:natanjir_mobile/providers/ocjena_proizvod_provider.dart';
import 'package:natanjir_mobile/providers/ocjena_restoran_provider.dart';
import 'package:natanjir_mobile/providers/product_provider.dart';
import 'package:natanjir_mobile/providers/restoran_favorit_provider.dart';
import 'package:natanjir_mobile/providers/restoran_provider.dart';
import 'package:natanjir_mobile/providers/stavke_narudzbe_provider.dart';
import 'package:natanjir_mobile/providers/vrsta_proizvodum_provider.dart';
import 'package:natanjir_mobile/providers/vrsta_restorana_provider.dart';
import 'package:natanjir_mobile/screens/product_list_screen.dart';
import 'package:natanjir_mobile/screens/registracija_screen.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var cart = FlutterCart();
  await cart.initializeCart(isPersistenceSupportEnabled: true);

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
                                  AuthProvider.password!);

                              if (korisnik.isDeleted!) {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: 'Račun deaktiviran',
                                  text: 'Vaš korisnički račun je deaktiviran.',
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
                              print("Authenticated!");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MasterScreen()));
                            } on Exception catch (e) {
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: e.toString());
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RichText(
                        text: TextSpan(
                          text: "Nemate korisnički račun? ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Kreirajte ga!",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          RegistracijaScreen()));
                                },
                            ),
                          ],
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
