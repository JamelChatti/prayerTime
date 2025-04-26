// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:flutter_qiblah/utils.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:prayertime/views/tab_views/location_search.dart';
//
// import 'location/location.dart';
// //
// // class MapScreen extends StatefulWidget {
// //   const MapScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<MapScreen> createState() => _MapScreenState();
// // }
// //
// // class _MapScreenState extends State<MapScreen> {
// //   late CameraPosition _cameraPosition;
// //   GoogleMapController? _mapController;
// //
// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     _cameraPosition =
// //         const CameraPosition(target: LatLng(45.521563, -122.677433), zoom: 17);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GetBuilder<LocationController>(builder: (locationController) {
// //       return Scaffold(
// //         appBar: AppBar(
// //           title: Text('Carte'),
// //           backgroundColor: Colors.green[700],
// //         ),
// //         body: Stack(
// //           children: [
// //             GoogleMap(
// //               onMapCreated: (GoogleMapController mapController) {},
// //               initialCameraPosition: _cameraPosition,
// //             ),
// //             Positioned(
// //                 top: 100,
// //                 left: 10,
// //                 right: 20,
// //                 child: GestureDetector(
// //                   onTap: () =>Get.dialog(LocationSearchDialog(mapController: _mapController)),
// //
// //
// //                   child: Container(
// //                     height: 50,
// //                     padding: const EdgeInsets.symmetric(horizontal: 5),
// //                     decoration: BoxDecoration(
// //                       color: Theme.of(context).cardColor,
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         Icon(
// //                           Icons.location_on,
// //                           size: 25,
// //                           color: Theme.of(context).primaryColor,
// //                         ),
// //                         const SizedBox(
// //                           width: 5,
// //                         ),
// //                         Expanded(
// //                             child: Text(
// //                           '${locationController.pickPlaceMark.name ?? ''}'
// //                           '${locationController.pickPlaceMark.locality ?? ''}'
// //                           '${locationController.pickPlaceMark.postalCode ?? ''}'
// //                           '${locationController.pickPlaceMark.country ?? ''}',
// //                           style: const TextStyle(fontSize: 20),
// //                           maxLines: 1,
// //                           overflow: TextOverflow.ellipsis,
// //                         )),
// //                         const SizedBox(
// //                           width: 10,
// //                         ),
// //                         Icon(
// //                           Icons.search,
// //                           size: 25,
// //                           color: Theme.of(context).primaryColor,
// //                         )
// //                       ],
// //                     ),
// //                   ),
// //                 ))
// //           ],
// //         ),
// //       );
// //     });
// //   }
// // }
//
// // class MapScreen extends StatefulWidget {
// //   const MapScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<MapScreen> createState() => _MapScreenState();
// // }
// //
// // class _MapScreenState extends State<MapScreen> {
// //   final Completer<GoogleMapController> _controller = Completer();
// //   static final CameraPosition  _initialCameraPosition = CameraPosition(target: target);
// //   LatLng currentLocation = _initialCameraPosition.target;
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         actions: [
// //           IconButton(onPressed: _showSearchDialog, icon: Icon(Icons.search))
// //         ],
// //       ),
// //       body:GoogleMap(
// //         initialCameraPosition: _initialCameraPosition,
// //         mapType: MapType.normal,
// //         onMapCreated: (controller) => _controller.complete(controller),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: ()=> _getMyLocation(),
// //         child: const Icon(Icons.gps_fixed),
// //       ),
// //       bottomNavigationBar: Container(
// //         height: 20,
// //         alignment: Alignment.center,
// //         child: Text("lat:${currentLocation.latitude},long:${currentLocation.longitude}"),
// //       )
// //     );
// //   }
// //   Future<void> _showSearchDialog() async{
// //     var p = await PlacesAutocomplete.show(context: context,
// //         apiKey: 'AIzaSyBVB2HLxdyG4Zt-067212h_LRcApdOUAsQ',
// //       mode: Mode.fullscreen,
// //       language: "ar",
// //       region: "ar",
// //       offset: 0,
// //       hint: "tappez ici...",
// //       radius: 1000,
// //       types: [],
// //       strictbounds: false,
// //       components: [Compoent(Component.country, "ar")],
// //       _getLocationFromPlaceId(p!.placeId!),
// //     );
// //   }
// // Future<void> _getLocationFromPlaceId(String placeId)async {
// // GoogleMapsPlaces _places =GooleMapsPlaces(
// //     apiKey:'AIzaSyBVB2HLxdyG4Zt-067212h_LRcApdOUAsQ',
// //   apiHeaders: await GoogleApiHeaders().getHeaders(),
// // );
// //   }
// // }
//
// import 'dart:async';
// import 'dart:math';
//
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:prayertime/common/utils.dart';
//
// const kGoogleApiKey = 'AIzaSyBVB2HLxdyG4Zt-067212h_LRcApdOUAsQ';
//
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// final homeScaffoldKey = GlobalKey<ScaffoldState>();
// final searchScaffoldKey = GlobalKey<ScaffoldState>();
//
//
//
// class _MapScreenState extends State<MapScreen> {
//   Mode _mode = Mode.overlay;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: homeScaffoldKey,
//
//       body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               //_buildDropdownMenu(),
//               ElevatedButton(
//                 onPressed: _handlePressButton,
//                 child: Text("Search places"),
//               ),
//               ElevatedButton(
//                 child: Text("Custom"),
//                 onPressed: () {
//                   Navigator.of(context).pushNamed("/search");
//                 },
//               ),
//             ],
//           )),
//     );
//
//
//
//   }
//
//   // Widget _buildDropdownMenu() => DropdownButton(
//   //   value: _mode,
//   //   items: const <DropdownMenuItem<Mode>>[
//   //     DropdownMenuItem<Mode>(
//   //       value: Mode.overlay,
//   //       child: Text("Overlay"),
//   //     ),
//   //     DropdownMenuItem<Mode>(
//   //       value: Mode.fullscreen,
//   //       child: Text("Fullscreen"),
//   //     ),
//   //   ],
//   //
//   //   onChanged: (m) {
//   //     setState(() {
//   //       _mode = m as Mode;
//   //     });
//   //   },
//   // );
//
//   void onError(PlacesAutocompleteResponse response) {
//     // homeScaffoldKey.currentState.showSnackBar(
//     //   SnackBar(content: Text(response.errorMessage!)),
//     // );
//   }
//
//   Future<void> _handlePressButton() async {
//     // show input autocomplete with selected mode
//     // then get the Prediction selected
//     Prediction? p = await PlacesAutocomplete.show(
//       context: context,
//       apiKey: kGoogleApiKey,
//       onError: onError,
//       mode: _mode,
//       language: "fr",
//       decoration: InputDecoration(
//         hintText: 'Search',
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide: BorderSide(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       components: [Component(Component.country, "fr")],
//     );
//
//     displayPrediction(p!, homeScaffoldKey.currentState!);
//   }
//
// }
//
//
// Future<void> displayPrediction(Prediction p, ScaffoldState scaffold) async {
//   if (p != null) {
//     // get detail (lat/lng)
//     GoogleMapsPlaces _places = GoogleMapsPlaces(
//       apiKey: kGoogleApiKey,
//       apiHeaders: await const GoogleApiHeaders().getHeaders(),
//     );
//     PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId!);
//     final lat = detail.result.geometry!.location.lat;
//     final lng = detail.result.geometry!.location.lng;
//     print("${p.description} - $lat/$lng");
//
//     // scaffold.showSnackBar(
//     //   SnackBar(content: Text("${p.description} - $lat/$lng")),
//     // );
//   }
// }
//
// // custom scaffold that handle search
// // basically your widget need to extends [GooglePlacesAutocompleteWidget]
// // and your state [GooglePlacesAutocompleteState]
// class CustomSearchScaffold extends PlacesAutocompleteWidget {
//   CustomSearchScaffold()
//       : super(
//     apiKey: kGoogleApiKey,
//     sessionToken: Uuid().generateV4(),
//     language: "en",
//     components: [Component(Component.country, "uk")],
//   );
//
//   @override
//   _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
// }
//
// class _CustomSearchScaffoldState extends PlacesAutocompleteState {
//   @override
//   Widget build(BuildContext context) {
//     final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());
//     final body = PlacesAutocompleteResult(
//       onTap: (p) {
//         displayPrediction(p, searchScaffoldKey.currentState!);
//       },
//       logo: Row(
//         children: [FlutterLogo()],
//         mainAxisAlignment: MainAxisAlignment.center,
//       ),
//     );
//     return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
//   }
//
//   @override
//   void onResponseError(PlacesAutocompleteResponse response) {
//     super.onResponseError(response);
//     // searchScaffoldKey.currentState.showSnackBar!(
//     //   SnackBar(content: Text(response.errorMessage!)),
//     // );
//
//   }
//
//   @override
//   void onResponse(PlacesAutocompleteResponse? response) {
//     super.onResponse(response);
//     if (response != null && response.predictions.isNotEmpty) {
//       // searchScaffoldKey.currentState.showSnackBar(
//       //   SnackBar(content: Text("Got answer")),
//       // );
//     }
//   }
// }
//
// class Uuid {
//   final Random _random = Random();
//
//   String generateV4() {
//     // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
//     final int special = 8 + _random.nextInt(4);
//
//     return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
//         '${_bitsDigits(16, 4)}-'
//         '4${_bitsDigits(12, 3)}-'
//         '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
//         '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
//   }
//
//   String _bitsDigits(int bitCount, int digitCount) =>
//       _printDigits(_generateBits(bitCount), digitCount);
//
//   int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);
//
//   String _printDigits(int value, int count) =>
//       value.toRadixString(16).padLeft(count, '0');
//
//
// }