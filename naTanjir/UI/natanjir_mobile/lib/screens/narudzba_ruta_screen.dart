// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:natanjir_mobile/models/lokacija.dart';
// import 'package:natanjir_mobile/models/search_result.dart';
// import 'package:natanjir_mobile/providers/lokacija_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:geolocator/geolocator.dart';

// class NarudzbaRutaScreen extends StatefulWidget {
//   int? kupacId;
//   String? googleMapApiKey;
//   NarudzbaRutaScreen({super.key, required this.kupacId}) {
//     googleMapApiKey =
//         const String.fromEnvironment("_googleMapApiKey", defaultValue: "");
//   }

//   @override
//   State<NarudzbaRutaScreen> createState() => _NarudzbaRutaScreenState();
// }

// class _NarudzbaRutaScreenState extends State<NarudzbaRutaScreen> {
//   late LokacijaProvider lokacijaProvider;
//   SearchResult<Lokacija>? lokacijaResult;
//   GoogleMapController? _mapController;
//   late LatLng _currentLocation;
//   bool _isLoading = true;
//   List<LatLng> _routePoints = [];
//   Set<Marker> _markers = {};
//   Polyline _routePolyline =
//       Polyline(polylineId: PolylineId("route"), points: []);

//   @override
//   void initState() {
//     super.initState();
//     _currentLocation = LatLng(0.0, 0.0);
//     lokacijaProvider = context.read<LokacijaProvider>();
//     _initForm();
//     _getLocation();
//   }

//   Future<void> _initForm() async {
//     lokacijaResult = await lokacijaProvider.get();
//     setState(() {});
//   }

//   Future<void> _getLocation() async {
//     var googleMapKey = dotenv.env['_googleMapApiKey'];

//     final url = Uri.parse(
//         'https://www.googleapis.com/geolocation/v1/geolocate?key=$googleMapKey');

//     try {
//       final response = await http.post(url);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         double latitude = data['location']['lat'];
//         double longitude = data['location']['lng'];

//         print("Current Position: $latitude, $longitude");

//         if (mounted) {
//           setState(() {
//             _currentLocation = LatLng(latitude, longitude);
//             _isLoading = false;
//             _markers.add(Marker(
//               markerId: MarkerId("currentLocation"),
//               position: _currentLocation,
//               icon: BitmapDescriptor.defaultMarkerWithHue(
//                   BitmapDescriptor.hueRed),
//             ));
//           });
//         }

//         _mapController
//             ?.moveCamera(CameraUpdate.newLatLngZoom(_currentLocation, 15.0));
//         _fetchRoute();
//       } else {
//         print('Greška prilikom dohvatanja lokacije: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Greška: $e');
//     }
//   }

//   Future<void> _fetchRoute() async {
//     var googleMapKey = dotenv.env['_googleMapApiKey'];

//     final lokacijaKupca = lokacijaResult?.result?.lastWhere(
//       (element) => element.korisnikId == widget.kupacId,
//       orElse: () => null!,
//     );

//     if (lokacijaKupca == null) {
//       print("Lokacija kupca nedostupna.");
//       return;
//     }

//     final geografskaDuzinaKupac = lokacijaKupca.geografskaDuzina ?? 0.0;
//     final geografskaSirinaKupac = lokacijaKupca.geografskaSirina ?? 0.0;

//     final url = Uri.parse(
//       'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation.latitude},${_currentLocation.longitude}&destination=$geografskaSirinaKupac,$geografskaDuzinaKupac&key=$googleMapKey',
//     );

//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final steps = data['routes'][0]['legs'][0]['steps'];

//       List<LatLng> route = [];
//       for (var step in steps) {
//         final startLat = step['start_location']['lat'];
//         final startLng = step['start_location']['lng'];
//         route.add(LatLng(startLat, startLng));
//       }

//       setState(() {
//         _routePoints = route;
//         _routePolyline = Polyline(
//           polylineId: PolylineId("route"),
//           points: _routePoints,
//           width: 4,
//           color: Colors.green,
//         );
//         _markers.add(Marker(
//           markerId: MarkerId("destination"),
//           position: LatLng(geografskaSirinaKupac, geografskaDuzinaKupac),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         ));
//       });

//       _mapController
//           ?.moveCamera(CameraUpdate.newLatLngZoom(_routePoints.last, 15.0));
//     } else {
//       print('Greška prilikom dohvatanja rute: ${response.statusCode}');
//     }
//   }

//   void _launchNavigation({
//     required double destinationLatitude,
//     required double destinationLongitude,
//   }) async {
//     final url = Uri.parse(
//         'google.navigation:q=$destinationLatitude,$destinationLongitude&mode=d');
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       print("Greška prilikom pokretanja google mapa.");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Stack(
//         children: [
//           _isLoading
//               ? Center(child: CircularProgressIndicator())
//               : GoogleMap(
//                   initialCameraPosition: CameraPosition(
//                     target: _currentLocation,
//                     zoom: 15.0,
//                   ),
//                   markers: _markers,
//                   polylines: {_routePolyline},
//                   onMapCreated: (controller) => _mapController = controller,
//                 ),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             child: FloatingActionButton(
//               onPressed: () {
//                 final lokacijaKupca = lokacijaResult?.result?.lastWhere(
//                   (element) => element.korisnikId == widget.kupacId,
//                   orElse: () => null!,
//                 );
//                 if (lokacijaKupca != null) {
//                   _launchNavigation(
//                     destinationLatitude: lokacijaKupca.geografskaSirina ?? 0.0,
//                     destinationLongitude: lokacijaKupca.geografskaDuzina ?? 0.0,
//                   );
//                 }
//               },
//               child: Icon(Icons.navigation),
//               tooltip: "Pokreni navigaciju",
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// //TODO ZA SUTRA: POKUSATI ODMA NA KLIK "NARUDZBA RUTA" 
// // U DETALJI_NARUDZBE_SCREEN POKRENUTI GUGL MAPE, I SAKRITI API KEY
// //testiraj vise telefona jer radi samo na jednom???
