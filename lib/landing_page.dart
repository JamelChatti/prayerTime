import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:prayertime/class/hive_masjid.dart';
import 'package:prayertime/common/HiveBoxesManager.dart';
import 'package:prayertime/common/constants.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/login_status_enum.dart';
import 'package:prayertime/home_page.dart';
import 'package:prayertime/services/auth_service.dart';
import 'package:prayertime/services/masjid_services.dart';

import 'common/masjid.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  LoginStatus _loginStatus = LoginStatus.loggedOff;
  bool _isInitialized = false;
  HiveBoxesManager hiveBoxesManager = HiveBoxesManager();

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> initGlobals() async {
    //init mainMasjid
    var mainMasjidBox = hiveBoxesManager.mainMasjidBox;
    HiveMasjid? hiveMainMasjid = mainMasjidBox.get(HiveBoxConst.mainMasjidKey);
    if (hiveMainMasjid != null) {
      mainMasjid = await MasjidService.getMasjidWithId(hiveMainMasjid.id);
    }
    //init myMasjids
    var myMasjidsBox = hiveBoxesManager.myMasjidsBox;
    List<HiveMasjid> myHiveMasjids = myMasjidsBox.values.toList();
    for (int i = 0; i < myHiveMasjids.length; i++) {
      HiveMasjid hiveMasjid = myHiveMasjids[i];
      MyMasjid? myMasjid = await MasjidService.getMasjidWithId(hiveMasjid.id);
      if (myMasjid == null) {
        myMasjidsBox.delete(hiveMasjid.id);
      } else {
        myMasjids.add(myMasjid);
      }
    }
  }

  void _initialize() async {

    // await hiveBoxesManager.deleteHiveBoxes();

    await hiveBoxesManager.initHiveBoxes();
    await initGlobals();

    final AuthService authService = AuthService();
    _loginStatus = await authService.checkIfLoggedIn();
    authService.initListener();

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
