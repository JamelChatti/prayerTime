

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prayertime/class/hive_masjid.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/introduction_to_my_msjid_box.dart';
import 'package:prayertime/services/adhan_service.dart';
import 'package:prayertime/services/masjid_services.dart';

class FavoriteMasjid extends StatefulWidget {
  const FavoriteMasjid({Key? key}) : super(key: key);

  @override
  State<FavoriteMasjid> createState() => _FavoriteMasjidState();
}

class _FavoriteMasjidState extends State<FavoriteMasjid> {
  //List<MyMasjid> masjids = [];

  var myMasjidsBox = Hive.box<HiveMasjid>('myMasjids');
  var mainMasjidsBox = Hive.box<HiveMasjid>('mainMasjid');
  List<MyMasjid> masjids = [];
  MasjidService masjidService = MasjidService();
  final Map<String, Image> _loadedImages = Map();
  late final Stream<DateTime> stream;
  LatLng? target;
  static final f1 = DateFormat('dd-MM-yyyy');
  static final f2 = DateFormat(' HH:mm');

  String locale = 'ar';

  //Suppose current gregorian data/time is: Mon May 29 00:27:33  2018
  final HijriCalendar _today = HijriCalendar.now();


  @override
  void initState() {
    super.initState();
    stream = Stream.periodic(
        const Duration(seconds: 1), (_) => DateTime.now());

  }

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
        itemCount: myMasjidsBox.length,
        itemBuilder: (context, index) {
          HiveMasjid masjid = myMasjidsBox.values.elementAt(index);
          PrayerTimesMasjid prayerTimesManager = PrayerTimesMasjid(masjid.latitude, masjid.longitude);

          return ListTile(
        isThreeLine: true,
        onTap: () {
          //TODO delete
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IntroductionToMyMasjidBox(
                    masjid: myMasjidsBox.values.elementAt(index),
                  )));
        },

        title: Text(
          myMasjidsBox.values.elementAt(index).name.trim(),
          style: TextStyle(
              fontSize: 15,
              color: Colors.blue.shade800,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          children: [
            // Text(
            //   "${myMasjidsBox.values.elementAt(index).address}\n",
            //   style: const TextStyle(
            //       fontSize: 15,
            //       color: Colors.black,
            //       fontWeight: FontWeight.bold),
            // ),
            Row(
              children: const [
                Expanded(flex: 2,
                  child: Text(
                    "Fajr",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(flex: 3,
                child:Text(
                  "Chourouk",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
          Expanded(flex: 2,
          child: Text(
                  "Dhuhr",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
          Expanded(flex: 2,
          child:Text(
                  "Asr",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
          Expanded(flex: 3,
          child:Text(
                  "Meghrib",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
          Expanded(flex: 2,
          child:Text(
                  "Isha",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),

              ],
            ),
            Row(
              children: [
                Expanded(flex: 2,
                  child: Text(
                    prayerTimesManager.fajr,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(flex: 3,
                    child:Text(
                      prayerTimesManager.sunrise,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),
                Expanded(flex: 2,
                    child: Text(
                      prayerTimesManager.dhuhr,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),
                Expanded(flex: 2,
                    child:Text(
                      prayerTimesManager.asr,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),
                Expanded(flex: 3,
                    child:Text(
                      prayerTimesManager.maghrib,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),
                Expanded(flex: 2,
                    child:Text(
                     prayerTimesManager.isha,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),

              ],
            ),
            // Row(
            //   children: [
            //     myMasjidsBox.values.elementAt(index).existJoumoua?
            //     Expanded(
            //       child: Column(
            //         children: [
            //           const Text('Joumoua'),
            //           Text(
            //             "${myMasjidsBox.values.elementAt(index).joumoua}\n",
            //             style: const TextStyle(
            //                 fontSize: 15,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //         ],
            //       ),
            //     ):Container(),
            //     myMasjidsBox.values.elementAt(index).existAid?
            //     Expanded(
            //       child: Column(
            //         children: [
            //           const Text('Aid'),
            //           Text(
            //             "${myMasjidsBox.values.elementAt(index).aid}\n",
            //             style: const TextStyle(
            //                 fontSize: 15,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //         ],
            //       ),
            //     ):Container(),
            //     myMasjidsBox.values.elementAt(index).existTahajod?
            //     Expanded(
            //       child: Column(
            //         children: [
            //           const Text('Tahajod'),
            //           Text(
            //             "${myMasjidsBox.values.elementAt(index).tahajod}\n",
            //             style: const TextStyle(
            //                 fontSize: 15,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //         ],
            //       ),
            //     ):Container(),
            //     myMasjidsBox.values.elementAt(index).womenMousalla?
            //     Expanded(
            //       child: Column(
            //         children:  const [
            //           Text('S.fem'),
            //           Icon(LineIcons.female),
            //
            //
            //         ],
            //       ),
            //     ):Container(),
            //     myMasjidsBox.values.elementAt(index).ablution?
            //     Expanded(
            //       child: Column(
            //         children: [
            //           const Text(
            //             "Ablution", ),
            //           Stack(
            //             children: [
            //               Image.asset('images/ablution.png', height: 20, width: 20),
            //
            //             ],
            //           )
            //
            //
            //         ],
            //       ),
            //     ):Container(),
            //     myMasjidsBox.values.elementAt(index).carPark?
            //
            //     Expanded(
            //       child: Column(
            //         children: const [
            //           Text('Parking'),
            //           Icon(LineIcons.parking),
            //         ],
            //       ),
            //     ):Container(),
            //
            //   ],
            // ),
          ],
        ),
        // leading: CircleAvatar(
        //   radius: 30,
        //   backgroundImage: _loadedImages[myMasjidsBox.values.elementAt(index).id]!.image,
        // ),

        //iconColor: ,
      );
       // ListTile(title: Text(myMasjidsBox.values.elementAt(index).name) );
      },
    );
  }

  Future<void> loadImages() async {
    for (var masjid in masjids) {
      await FirebaseStorage.instance
          .ref()
          .child(masjid.id)
          .child("images")
          .listAll()
          .then((value) async {
        var image = value.items.first;
        var url = await image.getDownloadURL();
        _loadedImages[masjid.id] = Image.network(url);
      });
    }
  }

}



class Clock extends StatelessWidget {
  final Stream<DateTime> stream;

  Clock({required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: stream,
      builder: (context, snapshot) {
        final dateTime = snapshot.data ?? DateTime.now();
        final formattedTime = DateFormat.Hms().format(dateTime);
        return Text(formattedTime,style: const TextStyle(fontSize: 20));
      },
    );
  }


}


