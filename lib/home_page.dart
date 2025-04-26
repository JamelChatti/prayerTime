import 'dart:io';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/login/login.dart';
import 'package:prayertime/views/my_drawer_views/my_drawer.dart';
import 'package:prayertime/views/tab_views/current_masjid//iquama.dart';
import 'package:prayertime/views/tab_views/favorite_masjids/favorite_masjid.dart';
import 'package:prayertime/views/tab_views/location_search.dart';
import 'package:prayertime/views/tab_views/near_masjids/near_masjids.dart';
import 'package:prayertime/views/tab_views/quibla/qibla_direction.dart';

const _kPages = <String, IconData>{
  '': Icons.search,
  'mosqu': Icons.mosque,
  'iqama': Icons.more_time,
  'quibla': LineIcons.kaaba,
  'localité': Icons.location_on,
};

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController masjidController = TextEditingController();
  PrayerTimesManager prayerTimesManager = PrayerTimesManager();
  Position? _position;
  static final f = DateFormat('dd-MM-yyyy  kk:mm');

  @override
  void initState() {
    //saveToken();
    imageCache.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset('images/logoPt.png',
                fit: BoxFit.contain,
                height: 50,

                 // AppLocalizations.of(context)!.iqama
              ),


            ],
          ),
          backgroundColor: Colors.transparent,

        ),
        drawer: const MyDrawer(),
        body: Container(
          color: Colors.indigo[100],
          child: Column(
            children: [
              //mainMasjidDropdown(),
              const Divider(),
              Expanded(
                child: TabBarView(
                  children: [
                    //for (final icon in _kPages.values) Icon(icon, size: 64),
                    NearMasjids(),
                    const FavoriteMasjid(),
                    CurrentMasjidIquama(),
                    QuiblaDirection(),
                    CitySearchScreen(),
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
            //   TabItem(icon: Icons.location_on, title: AppLocalizations.of(context)!.proximity),
            //   TabItem(icon: Icons.mosque,, title: AppLocalizations.of(context)!.favorite),
            //   TabItem(icon: Icons.more_time, title:AppLocalizations.of(context)!.iqama ),
            //   TabItem(icon: LineIcons.kaaba, title: AppLocalizations.of(context)!.quibla),
            //   TabItem(icon: Icons.people, title: AppLocalizations.of(context)!.city),
            for (final entry in _kPages.entries)
              TabItem(icon: entry.value, title: entry.key),
          ],
          onTap: (int i) => print('click index=$i'),
        ),
      ),
    );
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

        await _firestore
            .collection("tokens")
            .doc(result.docs.elementAt(0).id)
            .update({
          "token": token,
        });
      } else {
        List<String> myMasjidsid = [];
        // for (int i = 0; i < myMasjids.length; i++){
        //   myMasjidsid.add({
        //    myMasjids[i].id
        //   });}
        myMasjids.forEach((element) {
          myMasjidsid.add(element.id);
        });

        await _firestore.collection("tokens").doc().set({
          "token": token,
          "email": currentUser!.email,
          "model": deviceName,
          "favMassjid": FieldValue.arrayUnion(myMasjidsid),
          "date": DateTime.now()
        });
      }
    });
  }
}
