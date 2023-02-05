import 'dart:io';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prayertime/audio/audio_player.dart';
import 'package:prayertime/class/hive_masjid.dart';
import 'package:prayertime/class/near_masjid_response.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/current_masgid_iquama.dart';
import 'package:prayertime/geo_location.dart';
import 'package:prayertime/login/login.dart';
import 'package:prayertime/my_drawer.dart';
import 'package:prayertime/quibla/loading.dart';
import 'package:prayertime/quibla/qibla_direction.dart';
import 'package:prayertime/services/masjid_services.dart';

const _kPages = <String, IconData>{
  'home': Icons.location_on,
  'mosqu': Icons.mosque,
  'iqama': Icons.more_time,
  'quibla': LineIcons.kaaba,
  'people': Icons.people,
};

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var myMasjidsBox = Hive.box<HiveMasjid>('myMasjids');
  var mainMasjidsBox = Hive.box<HiveMasjid>('mainMasjid');

  MyMasjid? mainMasjid;
  List<HiveMasjid> myMasjids = [];
  PrayerTimesManager prayerTimesManager = PrayerTimesManager();
  Position? _position;
  bool isLoading = false;
  static final f = DateFormat('dd-MM-yyyy  kk:mm');

  @override
  void initState() {
    //saveToken();
    initData();
  }

  void initData() {
    myMasjids = myMasjidsBox.values.toList();
    HiveMasjid? hiveMainMasjid = mainMasjidsBox.get('mainMasjid');

    getMainMasjid(hiveMainMasjid);
  }

  void getMainMasjid(hiveMainMasjid) {
    if (mainMasjid == null || hiveMainMasjid.id != mainMasjid!.id) {
      mainMasjid = null;
      setState(() {
        isLoading = true;
      });
      if (hiveMainMasjid != null) {
        MasjidService.getMasjidWithId(hiveMainMasjid.id).then((value) {
          mainMasjid = value;
          setState(() {
            isLoading = false;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  updateDropdown() {
    setState(() {
      initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Accueil'),
          backgroundColor: Colors.indigo[900],
        ),
        drawer: MyDrawer(),
        body: Container(
          color: Colors.indigo[100],
          child: Column(
            children: [
              mainMasjidDropdown(),
              const Divider(),
              Expanded(
                child: TabBarView(
                  children: [
                    //for (final icon in _kPages.values) Icon(icon, size: 64),
                    const GeoLocation(),
                    NearMasjidResponse(parentSetState: updateDropdown),
                    CurrentMasjidIquama(
                        mainMasjid: mainMasjid, isLoading: isLoading),
                    QuiblaDirection(),
                    const AudioAdhenPlayer(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ConvexAppBar.badge(
          backgroundColor: Colors.indigo[900],
          const <int, dynamic>{3: ''},
          style: TabStyle.reactCircle,
          items: <TabItem>[
            for (final entry in _kPages.entries)
              TabItem(icon: entry.value, title: entry.key),
          ],
          onTap: (int i) => print('click index=$i'),
        ),
      ),
    );
  }

// Select style enum from dropdown menu:
  Widget mainMasjidDropdown() {
    Widget widget = isLoading
        ? LoadingIndicator()
        : mainMasjid != null
            ? DropdownButton<HiveMasjid>(
                value: mainMasjid == null
                    ? null
                    : myMasjids
                        .firstWhere((element) => mainMasjid!.id == element.id),
                onChanged: (newMainMasjid) {
                  if (newMainMasjid != null) {
                    mainMasjidsBox.put("mainMasjid", newMainMasjid);
                    getMainMasjid(newMainMasjid);
                    setState(() => {});
                  }
                },
                items: [
                  for (final masjid in myMasjids)
                    DropdownMenuItem(
                      value: masjid,
                      child: Text(masjid.name),
                    )
                ],
              )
            : Container();
    return widget;
  }

  Padding prayerTime() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Column(
          children: [
            Center(
              child: _position != null
                  ? Text('Localisation actuel: $_position ')
                  : const Text('Pas de localisation trouvée!'),
            ),
            Text(
              f.format(DateTime.now()),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
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
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Actualiser votre localisation'))
          ],
        ),
      ),
    );
  }

  Future? saveToken() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = "";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print("hello");
      deviceName = androidInfo.model;
    }

    FirebaseMessaging.instance.getToken().then((token) async {
      final QuerySnapshot result = await Future.value(FirebaseFirestore.instance
          .collection("tokens")
          .where("model", isEqualTo: deviceName)
          .where("email", isEqualTo: currentUser!.email)
          .limit(1)
          .get());
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 1) {
        // var asMap = (result.docs.elementAt(0).data() as Map<String, dynamic>);
        // if(!asMap.containsKey("email")){
        // }

        await FirebaseFirestore.instance
            .collection("tokens")
            .doc(result.docs.elementAt(0).id)
            .update({
          "token": token,
        });
      } else {
        await FirebaseFirestore.instance.collection("tokens").doc().set({
          "token": token,
          "email": currentUser!.email,
          "model": deviceName,
          "date": DateTime.now()
        });
      }
    });
  }
}
