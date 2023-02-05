//
//
// import 'package:flutter/cupertino.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:prayertime/class/map_location.dart';
//
// class CurrentMasjidLocation extends StatelessWidget {
//    CurrentMasjidLocation({Key? key, required this.target}) : super(key: key);
//    final LatLng target;
//    GoogleMapExampleAppPage googleMapExampleAppPage = GoogleMapExampleAppPage(
//       initialPosition:
//       CameraPosition(target: LatLng(37.4219999, -122.0840575)),
//     );
//   LatLng _target = LatLng(37.4219999, -122.0840575);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child:GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target:target ,
//             zoom: 15.0,
//           ),
//           markers: googleMapExampleAppPage.markers,
//           polygons: googleMapExampleAppPage.polygons,
//           polylines: googleMapExampleAppPage.polylines,
//           circles: googleMapExampleAppPage.circles,
//           // onMapCreated: (GoogleMapController controller) {
//           //   _controller = controller;
//           // },
//           // initialCameraPosition: CameraPosition(
//           //   target: initTarget!,
//           //   zoom: 3.0,
//           // ),
//           onTap: (value) {
//             print(value);
//
//           },
//         )
//     );
//   }
// }


import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class MyMap extends StatefulWidget {

  MyMap({Key? key, required this.target}) : super(key: key);
  final LatLng target;

  @override
  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController mapController;

   LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _center = widget.target;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
      markers: {
        Marker(
          markerId: const MarkerId("1"),
          position: _center,
          icon:  BitmapDescriptor.defaultMarker,


        ),
      },
    );
  }
}
