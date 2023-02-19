import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:prayertime/class/hive_masjid.dart';
import 'package:prayertime/class/mymasjid_adapter.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/login_status_enum.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/home_page.dart';
import 'package:prayertime/services/auth_service.dart';
import 'package:prayertime/services/masjid_services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hive/hive.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  LoginStatus _loginStatus = LoginStatus.loggedOff;
  final AuthService authService = AuthService();
  bool _isInitialized = false;
  final databaseReference = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    super.initState();
    authService.initListener();
    _initialize();
  }

  // void updateHiveFromFirebase() {
  //   databaseReference.child("your_database_path").once().then((DataSnapshot snapshot) {
  //     Map data = snapshot.value;
  //
  //     // Enregistrer les données mises à jour dans Hive
  //     Hive.box('your_box_name').put('your_key', data);
  //   });
  // }

  void _initialize() async {
    _loginStatus = await authService.checkIfLoggedIn();
    String favMasjidId = UtilsMasjid.localStorage!.getString("favMasjidId") ?? "";
    if (favMasjidId.isNotEmpty) {
      favMasjid = await MasjidService.getMasjidWithId(favMasjidId);
    }
    double? localLatitude = UtilsMasjid.localStorage!.getDouble("latitude");
    if (localLatitude != null) {
      latitude = localLatitude;
    }
    double? localLongitude = UtilsMasjid.localStorage!.getDouble("longitude");
    if (localLongitude != null) {
      longitude = localLongitude;
    }

    Hive.registerAdapter(HiveMasjidAdapter());

   // Hive.deleteBoxFromDisk("myMasjids");
   // Hive.deleteBoxFromDisk("mainMasjid");
    if (!Hive.isBoxOpen('myMasjids')) {
      await Hive.openBox<HiveMasjid>('myMasjids');
    }
    if (!Hive.isBoxOpen('mainMasjid')) {
      await Hive.openBox<HiveMasjid>('mainMasjid');
    }

    setState(() {
      _isInitialized = true;
    });
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized ? const HomePage() : Container();
  }
}
