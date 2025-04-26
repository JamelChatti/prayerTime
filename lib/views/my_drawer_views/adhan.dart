import 'dart:ui' as ui;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:prayertime/common/constants.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/common/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Adhan extends StatefulWidget {
  const Adhan({Key? key}) : super(key: key);

  @override
  State<Adhan> createState() => _AdhanState();
}

class _AdhanState extends State<Adhan> {
  final myCoordinates =
      Coordinates(35.741884, 10.575); // Replace with your own location lat, lng.

  //final params = CalculationMethod.muslim_world_league.getParameters();
  Position? _position;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<double> _latitude;
  late Future<double> _longitude;
  double locaLatitude =0;
  double locaLongitude =0;

  Future<void> _getCurrentLocation() async{
    Position position = await UtilsMasjid.determinePosition();
    setState(() {
      _position = position;
    });
  }


  Future<void> getLatitude() async {
    final SharedPreferences prefs = await _prefs;
    final double localLatitude = (prefs.getDouble('localLatitude')?? _position!.latitude) ;
    setState(() {
      _latitude = prefs.setDouble('localLatitude', localLatitude).then((bool success) {
        return localLatitude;
      });
    });
  }
  Future<void> getLongitude() async {
    final SharedPreferences prefs = await _prefs;
    final double locaLongitude = (prefs.getDouble('locaLongitude')?? _position!.longitude)  ;

    setState(() {
      _longitude = prefs.setDouble('locaLongitude', locaLongitude).then((bool success) {
        return locaLongitude;
      });
    });
  }

  PrayerTimesManager prayerTimesManager = PrayerTimesManager();

  final nyUtcOffset = const Duration(hours: 0);
  final nyDate = DateComponents(
      DateTime.now().year, DateTime.now().day, DateTime.now().month);
  final nyParams = CalculationMethod.muslim_world_league.getParameters();
  static final f = DateFormat('dd-MM-yyyy  kk:mm');
  List<Placemark>? placemarks;
  final HijriCalendar _today = HijriCalendar.now();

  void _getPlace(LatLng position) async {
    placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
  }

  void _getCurrentCity() async {
    await _getCurrentLocation();

    LatLng latLng = LatLng(_position!.latitude, _position!.longitude);

    _getPlace(latLng);
    if(mounted)
      setState(() {});
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
    _getCurrentCity();
    //paramMethode.madhab = Madhab.hanafi;
    nyParams.madhab = Madhab.hanafi;
    final localPlace = Coordinates(_position == null ? locaLatitude :_position!.latitude , _position == null ? locaLongitude :_position!.longitude);
    final nyPrayerTimes =
        PrayerTimes(localPlace, nyDate, nyParams, utcOffset: nyUtcOffset);
    print('Kushtia Prayer Times');

    //printDate(prayerTimes, nyPrayerTimes);
   // printDate(prayerTimes, nyPrayerTimes);
   //  _latitude = _prefs.then((SharedPreferences prefs) {
   //    return prefs.getDouble('locaLatitude') ?? 0;
   //  });
   //  _longitude = _prefs.then((SharedPreferences prefs) {
   //    return prefs.getDouble('locaLongitude') ?? 0;
   //  });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: const Text('أوقات الصلاة')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
        //   Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) =>  MasjidUpdate(user: currentUser, masjid: masjid))
        // );
         print (currentUser!.name);},
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Column(
            children: [

              // Center(
              //   child: _position != null ? Text('Localisation actuel: $_position ') : const Text('Pas de localisation trouvée!'),
              // ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: _position != null
                    ? Text('Localisation actuel: $_position ')
                    : const Text('Pas de localisation trouvée!'),
              ),
              Text(getLocation(_position!.latitude,_position!.longitude).toString()),
              placemarks != null
                  ? Column(
                children: [
                  Text(placemarks![0].locality.toString(),style:TextStyle(fontWeight: FontWeight.bold)),
                  Text(placemarks![0].country.toString(),style:TextStyle(fontWeight: FontWeight.bold)),
                ],
              )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  (_today.toFormat("dd MMMM yyyy")).toString(),
                  style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),
              ),
              Text(f.format(DateTime.now()),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),),
              Row(
                children: [
                  const Text('الفجر  '),
                  Text(prayerTimesManager.fajr),
                ],
              ),
              Row(
                children: [
                  const Text('الشروق '),
                  Text(prayerTimesManager.sunrise),
                ],
              ),
              Row(
                children: [
                  const Text('الظهر  '),
                  Text(prayerTimesManager.dhuhr),
                ],
              ),
              Row(
                children: [
                  const Text('العصر '),
                  Text(prayerTimesManager.asr),
                ],
              ),
              Row(
                children: [
                  const Text(' المغرب '),
                  Text(prayerTimesManager.maghrib),
                ],
              ),
              Row(
                children: [
                  const Text(' العشاء '),
                  Text(prayerTimesManager.isha),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }




  Future<String> getLocation(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      return "${place.locality}, ${place.country}";
    } catch (e) {
      return "Unable to get location";
    }
  }


}
