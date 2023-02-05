import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
//
// class LocationMasjid extends StatefulWidget {
//    const LocationMasjid({Key? key}) : super(key: key);
//
//    @override
//    State<LocationMasjid> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<LocationMasjid> {
//    final Completer<GoogleMapController> _controller =
//    Completer<GoogleMapController>();
//
//    static const CameraPosition _kGooglePlex = CameraPosition(
//       target: LatLng(0,0),
//       zoom: 3,
//    );
//
//    static const CameraPosition _kLake = CameraPosition(
//        bearing: 0,
//        target: LatLng(0, 0),
//        tilt: 0,
//        zoom: 3);
//
//
//
//    @override
//    Widget build(BuildContext context) {
//       return Scaffold(
//          body: GoogleMap(
//             mapType: MapType.hybrid,
//             initialCameraPosition: _kGooglePlex,
//             onMapCreated: (GoogleMapController controller) {
//                _controller.complete(controller);
//             },
//          ),
//          // floatingActionButton: FloatingActionButton.extended(
//          //    onPressed: _goToTheLake,
//          //    label: const Text('To the lake!'),
//          //    icon: const Icon(Icons.directions_boat),
//          // ),
//       );
//    }
//
//    Future<void> _goToTheLake() async {
//       final GoogleMapController controller = await _controller.future;
//       controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//    }
// }

class LocationMasjid extends StatefulWidget {
   @override
   _LocationMasjidState createState() => _LocationMasjidState();
}

class _LocationMasjidState extends State<LocationMasjid> {
   GoogleMapController? _controller;  //declare _controller
   LatLng _center = LatLng(35.72917, 10.58082);  // Paris
   @override
   Widget build(BuildContext context) {
      return Scaffold(
         body: GoogleMap(

            initialCameraPosition: CameraPosition(
               target: _center,
               zoom: 11.0,
            ),
            onTap: (value){
               print(value);
               _center=value;
               print(_center);
            },
         ),
      );
   }

}