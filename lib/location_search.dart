// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
//
// import 'location.dart';
//
// class LocationSearchDialog extends StatelessWidget {
//   final GoogleMapController? mapController;
//   const LocationSearchDialog({super.key, required this.mapController}) ;
//
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController _controller =TextEditingController();
//     return Container(
//       margin: const EdgeInsets.only(top: 150),
//       padding: const EdgeInsets.all(5),
//       alignment: Alignment.topCenter,
//       child: Material(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//         child: SizedBox(width: 350, child:
//         Scrollable(
//           viewportBuilder: (BuildContext context, ViewportOffset position) =>  TypeAheadField(
//             textFieldConfiguration: TextFieldConfiguration(
//               controller: _controller,
//               textInputAction: TextInputAction.search,
//               autofocus: true,
//               textCapitalization: TextCapitalization.words,
//               keyboardType: TextInputType.streetAddress,
//               decoration: InputDecoration(
//                 hintText: 'search_location',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(style: BorderStyle.none, width: 0),
//                 ),
//                 hintStyle: Theme.of(context).textTheme.headline2?.copyWith(
//                   fontSize: 16, color: Theme.of(context).disabledColor,
//                 ),
//                 filled: true, fillColor: Theme.of(context).cardColor,
//               ),
//               style: Theme.of(context).textTheme.headline2?.copyWith(
//                 color: Theme.of(context).textTheme.bodyText1?.color, fontSize: 20,
//               ),
//             ),
//             suggestionsCallback: (pattern) async {
//               return await Get.find<LocationController>().searchLocation(context, pattern);
//             },
//             itemBuilder: (context, Prediction suggestion) {
//               return Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Row(children: [
//                   const Icon(Icons.location_on),
//                   Expanded(
//                     child: Text(suggestion.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headline2?.copyWith(
//                       color: Theme.of(context).textTheme.bodyText1?.color, fontSize: 20,
//                     )),
//                   ),
//                 ]),
//               );
//             },
//             onSuggestionSelected: (Prediction suggestion) {
//               print("My location is ${suggestion.description!}");
//               // Get.find<LocationController>().setLocation(suggestion.placeId!, suggestion.description!, mapController);
//               Get.back();
//             },
//           ),
//         )
//
//
//     ),
//       ),
//     );
//   }
// }

import 'dart:ui' as ui;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/services/adhan_service.dart';
import 'package:timezone/standalone.dart' as tz;



class CitySearchScreen extends StatefulWidget {
  @override
  _CitySearchScreenState createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  LatLng? _location;
  PrayerTimesMasjid? prayerTimesManager;
  late PrayerTimes prayerTimes;

  final HijriCalendar _today = HijriCalendar.now();

  List<Placemark>? placemarks;

  HijriCalendar now = HijriCalendar.now();
  String? month;
  String _searchedTimeZone = "";
  var _searchedLocation;

  final nowM = DateTime.now();
  int year =0;
 String  _fajrTime = '';
  String  _sunriseTime = '';
  String  _dhuhrTime = '';
  String  _asrTime = '';
  String  _maghribTime = '';
  String  _ishaTime = '';

  void _getPrayerTimes(double latitude, double longitude, String timeZone) {
    final params = CalculationMethod.north_america.getParameters();

    params.madhab = Madhab.hanafi;
    final prayerTimes = PrayerTimes.today(
        Coordinates(latitude, longitude), params);

    var location = tz.getLocation(_searchedTimeZone);
    print(DateFormat('jm').format(prayerTimes.fajr));
    print(DateFormat('jm').format(tz.TZDateTime.from(prayerTimes.fajr, location)));

    // setState(() async {
    //   _fajrTime = DateFormat('jm').format(prayerTimes.fajr);
    //   _sunriseTime = DateFormat('jm').format(prayerTimes.sunrise);
    //   _dhuhrTime = DateFormat('jm').format(prayerTimes.dhuhr);
    //   _asrTime = DateFormat('jm').format(prayerTimes.asr);
    //   _maghribTime = DateFormat('jm').format(prayerTimes.maghrib);
    //   _ishaTime = DateFormat('jm').format(prayerTimes.isha);
    // });
  }



  Future<void> _getPlace(LatLng position) async {
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMonthHijriInArabic();



    // prayerTimesManager = PrayerTimesMasjid(_location!.latitude, _location!.longitude);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  Future<void> _searchLocation() async {
    String address = _searchController.text;
    if (address != null && address.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(address);
        if (locations.isNotEmpty) {
          Location location = locations.first;
          _location = LatLng(location.latitude, location.longitude);
          _searchedTimeZone = await UtilsMasjid.getTimezone(location.latitude, location.longitude);
          _searchedLocation = tz.getLocation(_searchedTimeZone);
          final params = CalculationMethod.north_america.getParameters();

          params.madhab = Madhab.hanafi;
           prayerTimes = PrayerTimes.today(
              Coordinates(location.latitude, location.longitude), params);

          prayerTimesManager =
              PrayerTimesMasjid(_location!.latitude, _location!.longitude);

          await _getPlace(_location!);
          //_getPrayerTimes(location.latitude,location.longitude, timeZone);
          setState(() {

          });
        } else {
          setState(() {
            _location = null;
          });
        }
      } catch (e) {
        print("Error getting location from address: $e");
        setState(() {
          _location = null;
        });
      }
    } else {
      setState(() {
        _location = null;
      });
    }
  }

  void getMonthHijriInArabic() {
    switch (int.parse(now.hMonth.toString().padLeft(2, '0'))) {
      case 1:
        month = "محرم";
        break;
      case 2:
        month = "صفر";
        break;
      case 3:
        month = "ربيع الأول";
        break;
      case 4:
        month = "ربيع الثاني";
        break;
      case 5:
        month = "جمادى الأول";
        break;
      case 6:
        month = "جمادى الثاني";
        break;
      case 7:
        month = "رجب";
        break;
      case 8:
        month = "شعبان";
        break;
      case 9:
        month = "رمضان";
        break;
      case 10:
        month = "شوال";
        break;
      case 11:
        month = "ذو القعدة";
        break;
      case 12:
        month = "وذو الحجة";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Enter a city name",
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: _searchLocation,
            ),
          ),
        ),
      ),
      body: _location == null
          ? const Center(child: Text("Enter a city name to search"))
          : ListView(
              children: [
                SizedBox(
                  height: 150,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _location!,
                      zoom: 12,
                    ),
                    markers: <Marker>{
                      Marker(
                        markerId: const MarkerId("searched-location"),
                        position: _location!,
                        infoWindow: const InfoWindow(
                          title: "Searched location",
                        ),
                      ),
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Column(
                      children: [
                        // Center(
                        //   child: _position != null ? Text('Localisation actuel: $_position ') : const Text('Pas de localisation trouvée!'),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _location != null
                              ? Text(' $_location ',style: TextStyle(fontSize: 10))
                              : const Text('Pas de localisation trouvée!',),
                        ),
                        placemarks != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(placemarks![0].country.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(placemarks![0].locality.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            '${now.hDay.toString().padLeft(2, '0')} ${month} ${now.hYear.toString()}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        // Text(f.format(DateTime.now()),
                        //   style: const TextStyle(
                        //       fontWeight: FontWeight.bold, fontSize: 18),),
                        Row(
                          children: [
                            const Expanded(flex:1,child: Text('الفجر  ')),
                            Expanded(flex:2,child: Text(_searchedTimeZone.isEmpty ? prayerTimesManager!.fajr : DateFormat('jm').format(tz.TZDateTime.from(prayerTimes!.fajr, _searchedLocation)))),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex:1,child:Text('الشروق ')),
                            Expanded(flex:2,child: Text(_searchedTimeZone.isEmpty ? prayerTimesManager!.sunrise : DateFormat('jm').format(tz.TZDateTime.from(prayerTimes!.sunrise, _searchedLocation)))),

                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex:1,child:Text('الظهر  ')),
                            Expanded(flex:2,child: Text(_searchedTimeZone.isEmpty ? prayerTimesManager!.dhuhr : DateFormat('jm').format(tz.TZDateTime.from(prayerTimes!.dhuhr, _searchedLocation)))),

                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex:1,child:Text('العصر ')),
                            Expanded(flex:2,child: Text(_searchedTimeZone.isEmpty ? prayerTimesManager!.asr : DateFormat('jm').format(tz.TZDateTime.from(prayerTimes!.asr, _searchedLocation)))),

                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex:1,child:Text(' المغرب ')),
                            Expanded(flex:2,child: Text(_searchedTimeZone.isEmpty ? prayerTimesManager!.maghrib : DateFormat('jm').format(tz.TZDateTime.from(prayerTimes!.maghrib, _searchedLocation)))),

                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(flex:1,child:Text(' العشاء ')),
                            Expanded(flex:2,child: Text(_searchedTimeZone.isEmpty ? prayerTimesManager!.isha : DateFormat('jm').format(tz.TZDateTime.from(prayerTimes!.isha, _searchedLocation)))),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
