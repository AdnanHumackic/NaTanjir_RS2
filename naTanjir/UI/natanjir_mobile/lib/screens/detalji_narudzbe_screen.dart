import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:natanjir_mobile/models/korisnici.dart';
import 'package:natanjir_mobile/models/lokacija.dart';
import 'package:natanjir_mobile/models/narudzba.dart';
import 'package:natanjir_mobile/models/search_result.dart';
import 'package:natanjir_mobile/models/stavke_narudzbe.dart';
import 'package:natanjir_mobile/providers/auth_provider.dart';
import 'package:natanjir_mobile/providers/korisnici_provider.dart';
import 'package:natanjir_mobile/providers/lokacija_provider.dart';
import 'package:natanjir_mobile/providers/narudzba_provider.dart';
import 'package:natanjir_mobile/providers/stavke_narudzbe_provider.dart';
import 'package:natanjir_mobile/providers/utils.dart';
import 'package:natanjir_mobile/screens/narudzba_ruta_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class DetaljiNarudzbeScreen extends StatefulWidget {
  final Narudzba? narudzba;
  String? googleMapApiKey;

  DetaljiNarudzbeScreen({super.key, required this.narudzba}) {
    googleMapApiKey =
        const String.fromEnvironment("_googleMapApiKey", defaultValue: "");
  }

  @override
  State<DetaljiNarudzbeScreen> createState() => _DetaljiNarudzbeScreenState();
}

class _DetaljiNarudzbeScreenState extends State<DetaljiNarudzbeScreen> {
  late LokacijaProvider lokacijaProvider;
  SearchResult<Lokacija>? lokacijaResult;
  GoogleMapController? _mapController;
  late LatLng _currentLocation;
  bool _isLoading = true;
  List<LatLng> _routePoints = [];
  Set<Marker> _markers = {};
  Polyline _routePolyline =
      Polyline(polylineId: PolylineId("route"), points: []);

  late StavkeNarudzbeProvider stavkeNarudzbeProvider;
  late KorisniciProvider korisniciProvider;
  late NarudzbaProvider narudzbaProvider;

  SearchResult<StavkeNarudzbe>? stavkeNarudzbeResult;
  SearchResult<Korisnici>? korisnikResult;

  Map<String, dynamic> searchRequest = {};

  @override
  void initState() {
    super.initState();
    searchRequest = {
      'narudzbaId': widget.narudzba!.narudzbaId,
      'isProizvodIncluded': true,
      'isRestoranIncluded': true,
    };
    stavkeNarudzbeProvider = context.read<StavkeNarudzbeProvider>();
    korisniciProvider = context.read<KorisniciProvider>();
    narudzbaProvider = context.read<NarudzbaProvider>();
    lokacijaProvider = context.read<LokacijaProvider>();
    _currentLocation = LatLng(0.0, 0.0);
    if (AuthProvider.korisnikUloge != null &&
        AuthProvider.korisnikUloge!.any((x) => x.uloga?.naziv == "Dostavljac"))
      _getLocation();

    _initForm();
  }

  Future _initForm() async {
    stavkeNarudzbeResult = await stavkeNarudzbeProvider.get(
      filter: searchRequest,
    );
    korisnikResult = await korisniciProvider.get();
    lokacijaResult = await lokacijaProvider
        .get(filter: {'korisnikId': widget.narudzba!.korisnikId});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 83, 86),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Narudžba broj: #${widget.narudzba!.brojNarudzbe}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: _buildPage(),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    if (AuthProvider.korisnikUloge != null &&
        AuthProvider.korisnikUloge!
            .any((x) => x.uloga?.naziv == "Dostavljac")) {
      return Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Divider(
              color: Colors.grey,
              thickness: 1,
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await narudzbaProvider.zavrsi(widget.narudzba!.narudzbaId!);
                    Navigator.pop(context, true);
                    await ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Color.fromARGB(255, 0, 83, 86),
                        duration: Duration(seconds: 1),
                        content: Center(
                          child: Text(
                              "Narudžba #${widget.narudzba!.brojNarudzbe} je završena."),
                        ),
                      ),
                    );
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 83, 86),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Završi narudžbu",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildHeader() {
    if (stavkeNarudzbeResult == null || stavkeNarudzbeResult!.result.isEmpty) {
      return SizedBox.shrink();
    }

    final stavkaNarudzbe = stavkeNarudzbeResult!.result.first;
    final restoran = stavkaNarudzbe.restoran;

    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: SizedBox(
                width: 90,
                height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: restoran != null &&
                          restoran!.slika != null &&
                          restoran!.slika!.isNotEmpty
                      ? imageFromString(restoran!.slika!)
                      : Image.asset(
                          "assets/images/restoranImg.png",
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restoran?.naziv ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    restoran?.lokacija ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage() {
    if (stavkeNarudzbeResult == null) {
      return Center(child: CircularProgressIndicator());
    }
    if (stavkeNarudzbeResult!.result.isEmpty) {
      return Center(
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 83, 86),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              ".",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Narudžba kreirana: ${formatDateTime(widget.narudzba!.datumKreiranja.toString())}",
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 108, 108, 108),
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Status narudžbe: ${widget.narudzba!.stateMachine}",
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 108, 108, 108),
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: korisnikResult!.result
                  .where((element) =>
                      element.korisnikId == widget.narudzba?.korisnikId)
                  .map((e) => Text(
                        "Narudžbu kreirao/la: ${e.ime} ${e.prezime}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 108, 108, 108),
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(thickness: 1, color: Colors.grey),
          ...stavkeNarudzbeResult!.result
              .map(
                (e) => Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${e.proizvod!.naziv} x${e.kolicina}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${formatNumber(e.cijena)} KM",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          if (AuthProvider.korisnikUloge != null &&
              AuthProvider.korisnikUloge!
                  .any((x) => x.uloga?.naziv == "Dostavljac"))
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () async {
                  final lokacijaKupca =
                      lokacijaResult?.result.isNotEmpty == true
                          ? lokacijaResult!.result.first
                          : null;

                  if (lokacijaKupca != null) {
                    _launchNavigation(
                      destinationLatitude:
                          lokacijaKupca.geografskaSirina ?? 0.0,
                      destinationLongitude:
                          lokacijaKupca.geografskaDuzina ?? 0.0,
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 83, 86),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: Text(
                      "Narudžba ruta",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          Divider(thickness: 1, color: Colors.grey),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 83, 86),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ukupno:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Flexible(
                  child: Text(
                    "${formatNumber(widget.narudzba!.ukupnaCijena)} KM",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getLocation() async {
    var googleMapKey = dotenv.env['_googleMapApiKey'];

    final url = Uri.parse(
        'https://www.googleapis.com/geolocation/v1/geolocate?key=$googleMapKey');

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        double latitude = data['location']['lat'];
        double longitude = data['location']['lng'];

        print("Current Position: $latitude, $longitude");

        if (mounted) {
          setState(() {
            _currentLocation = LatLng(latitude, longitude);
            _isLoading = false;
            _markers.add(Marker(
              markerId: MarkerId("currentLocation"),
              position: _currentLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
            ));
          });
        }

        _mapController
            ?.moveCamera(CameraUpdate.newLatLngZoom(_currentLocation, 15.0));
        _fetchRoute();
      } else {
        print('Greška prilikom dohvatanja lokacije: ${response.statusCode}');
      }
    } catch (e) {
      print('Greška: $e');
    }
  }

  Future<void> _fetchRoute() async {
    var googleMapKey = dotenv.env['_googleMapApiKey'];

    final lokacijaKupca = lokacijaResult?.result.isNotEmpty == true
        ? lokacijaResult!.result.first
        : null;
    if (lokacijaKupca == null) {
      print("Lokacija kupca nedostupna.");
      return;
    }

    final geografskaDuzinaKupac = lokacijaKupca.geografskaDuzina ?? 0.0;
    final geografskaSirinaKupac = lokacijaKupca.geografskaSirina ?? 0.0;

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation.latitude},${_currentLocation.longitude}&destination=$geografskaSirinaKupac,$geografskaDuzinaKupac&key=$googleMapKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final steps = data['routes'][0]['legs'][0]['steps'];

      List<LatLng> route = [];
      for (var step in steps) {
        final startLat = step['start_location']['lat'];
        final startLng = step['start_location']['lng'];
        route.add(LatLng(startLat, startLng));
      }

      setState(() {
        _routePoints = route;
        _routePolyline = Polyline(
          polylineId: PolylineId("route"),
          points: _routePoints,
          width: 4,
          color: Colors.green,
        );
        _markers.add(Marker(
          markerId: MarkerId("destination"),
          position: LatLng(geografskaSirinaKupac, geografskaDuzinaKupac),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
      });

      _mapController
          ?.moveCamera(CameraUpdate.newLatLngZoom(_routePoints.last, 15.0));
    } else {
      print('Greška prilikom dohvatanja rute: ${response.statusCode}');
    }
  }

  void _launchNavigation({
    required double destinationLatitude,
    required double destinationLongitude,
  }) async {
    final url = Uri.parse(
        'google.navigation:q=$destinationLatitude,$destinationLongitude&mode=d');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Greška prilikom pokretanja google mapa.");
    }
  }
}
