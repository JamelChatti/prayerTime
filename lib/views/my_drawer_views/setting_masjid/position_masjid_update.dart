import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prayertime/common/utils.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prayertime/class/map_location.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/class/user.dart';


class PositionMasjidUpdate extends StatefulWidget {
  final MyUser user;
  final MyMasjid masjid;
  const PositionMasjidUpdate({Key? key, required this.user,
    required this.masjid,}) : super(key: key);

  @override
  State<PositionMasjidUpdate> createState() => _PositionMasjidUpdateState();
}

class _PositionMasjidUpdateState extends State<PositionMasjidUpdate> {

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  GoogleMapController? _controller;

  LatLng _center = LatLng(0, 0);
  LatLng? initTarget;

  LatLng? position;

  List<Placemark>? placemarks;
  GoogleMapExampleAppPage googleMapExampleAppPage = GoogleMapExampleAppPage(
      initialPosition:
      const CameraPosition(target: LatLng(37.4219999, -122.0840575)));

  Marker marker = const Marker(markerId: MarkerId("1"));

  void _onMarkerTapped(String markerId) {
    print("Marker Tapped: $markerId");
  }

  void _getPlace(LatLng position) async {
    placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    // this is all you need
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTarget =
        LatLng(widget.masjid.positionMasjid.latitude, widget.masjid.positionMasjid.longitude);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Position de la mosquée'),
      ),
body: Column(
  children: [
    const Center(
        child: Text(
          'LOCALISATION DU MASJID',
          style: TextStyle(
              fontSize: 15,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold),
        )),
    SizedBox(
        height: 400,
        width: 350,
        child: GoogleMap(
          myLocationButtonEnabled: true,
          initialCameraPosition: CameraPosition(
            target: initTarget!,
            zoom: 20.0,
          ),
          //markers: googleMapExampleAppPage.markers,
          polygons: googleMapExampleAppPage.polygons,
          polylines: googleMapExampleAppPage.polylines,
          circles: googleMapExampleAppPage.circles,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
          markers: {marker},

          onTap: (value) {
            print(value);
            setState(() {
              marker = Marker(
                  draggable: true,
                  markerId: const MarkerId("1"),
                  position: value,
                  icon: BitmapDescriptor.defaultMarker,
                  onTap: () {
                    _onMarkerTapped("1");
                  });
              _center = value;
            });
            print(_center);
            _getPlace(_center);
            // print(placemarks![0].locality);
            // print(placemarks![0].country);
          },
        )),
    const SizedBox(
      height: 10,
    ),
    placemarks != null
        ? Text(
        '${placemarks![0].locality}  ${placemarks![0].country}')
        : Container(),
    Column(
      children: [
        ElevatedButton(onPressed: (){
          updateGeoPointMasjid();
          UtilsMasjid().toastMessage("Position enregistrée avec succés", Colors.blueAccent);
        }, child: const Text('Valider')),
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        },   child: const Text('Quitter',style: TextStyle(fontSize: 18),),)
      ],
    )
  ],
),
    );
  }
  Future<bool> updateGeoPointMasjid() async {
    bool success = false;
    await FirebaseFirestore.instance
        .collection('masjids')
        .doc(widget.masjid.id)
        .update({
      'positionMasjid': GeoPoint(_center.latitude, _center.longitude),
    });
    return success;
  }
}
