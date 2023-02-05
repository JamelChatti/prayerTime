// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
//
// class CityLocation extends StatefulWidget {
//   @override
//   _CityLocationState createState() => _CityLocationState();
// }
//
// class _CityLocationState extends State<CityLocation> {
//   Position _position;
//   Placemark _placemark;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   void _getCurrentLocation() async {
//     final cityName = "Paris";
//
//     _position = await Geolocator().getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//
//     _placemark = await Geolocator().placemarkFromPosition(_position);
//
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("City Location"),
//       ),
//       body: Center(
//         child: _placemark != null
//             ? Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("City name: ${_placemark.locality}"),
//             Text("Country name: ${_placemark.country}"),
//             Text("Latitude: ${_position.latitude}"),
//             Text("Longitude: ${_position.longitude}"),
//           ],
//         )
//             : CircularProgressIndicator(),
//       ),
//     );
//   }
// }
