import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/common/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeoLocation extends StatefulWidget {
  const GeoLocation({Key? key}) : super(key: key);

  @override
  State<GeoLocation> createState() => _GeoLocationState();
}

class _GeoLocationState extends State<GeoLocation> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  LatLng? latLng;
  Position? _position;
  TextEditingController _address =TextEditingController();
  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    //print(position.latitude) ;
    //print(position.latitude) ;
    Utils.localStorage!.setDouble("latitude", position.latitude);
    Utils.localStorage!.setDouble("longitude", position.longitude);
    latitude = position.latitude;
    longitude = position.longitude;
    _position = position;
    LatLng latLng = LatLng(_position!.latitude, _position!.longitude);

    _getPlace(latLng);
    if(mounted)
    setState(() {});
  }

  List<Placemark>? placemarks;


  void _getPlace(LatLng position) async {
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('L\'autorisation de localisation est refusée');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localisation'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: CircleAvatar(
                radius: 20,
                child: IconButton(
                    onPressed: _getCurrentLocation,
                    icon: const Icon(LineIcons.locationArrow))),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: _position != null
                ? Text('Localisation actuel: $_position ')
                : const Text('Pas de localisation trouvée!'),
          ),
          placemarks != null
              ? Column(
                  children: [
                    Text(placemarks![0].locality.toString()),
                    Text(placemarks![0].country.toString()),
                  ],
                )
              : Container(),
          Row(
            children: const [
              Text('Chercher une localité:'),
              Icon(Icons.search),

            ],
          ),
          // TextFormField(
          //   decoration: const InputDecoration(
          //       border: InputBorder.none,
          //       contentPadding: EdgeInsets.only(left: 15),
          //       hintText: 'Msaken',
          //       hintStyle: TextStyle(
          //           fontSize: 14,
          //           color: Colors.blueAccent,
          //           fontFamily: "Open Sans",
          //           fontWeight: FontWeight.normal
          //       )),
          //   maxLines: 1,
          //   controller: _address,
          //   onTap: ()async{
          //     // then get the Prediction selected
          //     Prediction p = await PlacesAutocomplete.show(
          //         context: context, apiKey: kGoogleApiKey,
          //         onError: onError);
          //     displayPrediction(p);
          //   },
          // )

        ],
      ),
    );
  }
  // Future<Null> displayPrediction(Prediction p) async {
  //   if (p != null) {
  //     PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
  //
  //     var placeId = p.placeId;
  //     lat = detail.result.geometry.location.lat;
  //     long = detail.result.geometry.location.lng;
  //
  //     var address  =detail.result.formattedAddress;
  //
  //     print(lat);
  //     print(long);
  //     print(address);
  //
  //     setState(() {
  //       _address.text = address;
  //     });
  //   }
  // }

}


