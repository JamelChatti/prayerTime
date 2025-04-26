import 'package:maps_launcher/maps_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key, required this.target}) : super(key: key);
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
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: {
            Marker(
              markerId: const MarkerId("1"),
              position: _center,
              icon: BitmapDescriptor.defaultMarker,
            ),
          },
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                  onPressed: () => MapsLauncher.launchCoordinates(
                      widget.target.latitude, widget.target.longitude),
                  child: const Text("Itinéraire"))),
        )
      ],
    );
  }
}
