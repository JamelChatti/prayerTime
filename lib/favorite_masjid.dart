//
//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hijri/hijri_calendar.dart';
// import 'package:intl/intl.dart';
// import 'package:prayertime/class/current_masjid_location.dart';
// import 'package:prayertime/common/utils.dart';
// import 'package:prayertime/common/globals.dart';
// import 'package:prayertime/common/prayer_times.dart';
// import 'package:prayertime/services/masjid_services.dart';
//
// class CurrentMasjidIquama extends StatefulWidget {
//   const CurrentMasjidIquama({Key? key}) : super(key: key);
//
//   @override
//   State<CurrentMasjidIquama> createState() => _CurrentMasjidIquamaState();
// }
//
// class _CurrentMasjidIquamaState extends State<CurrentMasjidIquama> {
//   //List<MyMasjid> masjids = [];
//   late final Stream<DateTime> stream;
//   MasjidService masjidService = MasjidService();
//   PrayerTimesManager prayerTimesManager = PrayerTimesManager();
//   LatLng? target;
//   static final f1 = DateFormat('dd-MM-yyyy');
//   static final f2 = DateFormat(' HH:mm');
//
//   String locale = 'ar';
//
//   //Suppose current gregorian data/time is: Mon May 29 00:27:33  2018
//   HijriCalendar _today = HijriCalendar.now();
//   void getListMasjids() async {
//     //masjids = await masjidService.getNearMasjid(latitude! + 5, longitude);
//     target = LatLng(latitude, longitude);
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getListMasjids();
//     stream = Stream.periodic(
//         Duration(seconds: 1), (_) => DateTime.now());
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return favMasjid == null
//         ? Container()
//         : SizedBox(
//       height: 500,
//       child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     favMasjid!.name,
//                     style: TextStyle(
//                       fontSize: 15,
//                       color: Colors.blue.shade800,
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 50,
//                   ),
//                   CircleAvatar(
//                     radius: 20.0,
//                     backgroundColor: Colors.cyan,
//                     child: IconButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute<void>(
//                                   builder: (context) => CurrentMasjidLocation(
//                                       target: target!)));
//                         },
//                         icon: const Icon(
//                           Icons.edit_location,
//                           color: Colors.red,
//                         )),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         const Text('Localisation de la mosquée:'),
//                         Text(
//                             ' ${favMasjid!.masjidLatitude.toStringAsFixed(5)}, ${favMasjid!.masjidLongitude.toStringAsFixed(5)} '),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Text('Ville: ${favMasjid!.state} '),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(2.0),
//                     child: Text(
//                       (_today.toFormat("dd MMMM yyyy")).toString(),
//                       style: const TextStyle(fontSize: 20),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(2.0),
//                     child: Text(
//                       f1.format(DateTime.now()),
//                       style: const TextStyle(fontSize: 20),
//                     ),
//                   ),
//
//                   Clock(stream: stream,),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 58.0),
//                     child: Table(
//                       defaultVerticalAlignment:
//                       TableCellVerticalAlignment.middle,
//                       columnWidths: const {
//                         0: FractionColumnWidth(.40),
//                         1: FractionColumnWidth(.30),
//                         2: FractionColumnWidth(.50),
//                       },
//                       // border: TableBorder.all(color: Colors.black),
//                       children: [
//                         TableRow(children: [
//                           const Text('Fajr',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue,
//                               )),
//                           Text(prayerTimesManager.fajr,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               )),
//                           favMasjid!.fajr.fixed
//                               ? Text(favMasjid!.fajr.time.toString(),
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               ))
//                               : Text('+${favMasjid!.fajr.time}',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               )),
//                         ]),
//                         TableRow(children: [
//                           const Text('Dhuhr',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue,
//                               )),
//                           Text(prayerTimesManager.dhuhr,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               )),
//                           favMasjid!.dhuhr.fixed
//                               ? Text(favMasjid!.dhuhr.time.toString(),
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               ))
//                               : Text('+${favMasjid!.dhuhr.time}',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               )),
//                         ]),
//                         TableRow(children: [
//                           const Text('Asr',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue,
//                               )),
//                           Text(prayerTimesManager.asr,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               )),
//                           favMasjid!.asr.fixed
//                               ? Text(favMasjid!.asr.time.toString(),
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               ))
//                               : Text('+${favMasjid!.asr.time}',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               )),
//                         ]),
//                         TableRow(children: [
//                           const Text('Maghrib',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue,
//                               )),
//                           Text(prayerTimesManager.maghrib,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               )),
//                           favMasjid!.maghrib.fixed
//                               ? Text(favMasjid!.maghrib.time.toString(),
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               ))
//                               : Text('+${favMasjid!.maghrib.time}',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               )),
//                         ]),
//                         TableRow(children: [
//                           const Text('Isha',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue,
//                               )),
//                           Text(prayerTimesManager.isha,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               )),
//                           favMasjid!.isha.fixed
//                               ? Text(favMasjid!.fajr.time.toString(),
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               ))
//                               : Text('+${favMasjid!.isha.time}',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               )),
//                         ]),
//                         favMasjid!.existJoumoua
//                             ? TableRow(children: [
//                           const Text('Joumoua',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue,
//                               )),
//                           Text(favMasjid!.joumoua.toString(),
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               )),
//                           const Text('')
//                         ])
//                             : const TableRow(children: [
//                           Text(''),
//                           Text(''),
//                           Text(''),
//                         ]),
//                         favMasjid!.existAid
//                             ? TableRow(children: [
//                           const Text('Aid',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue,
//                               )),
//                           Text(favMasjid!.aid,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               )),
//                           const Text('')
//                         ])
//                             : const TableRow(children: [
//                           Text(''),
//                           Text(''),
//                           Text(''),
//                         ]),
//                         favMasjid!.existtAhajod
//                             ? TableRow(children: [
//                           const Text('Tahajod',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue,
//                               )),
//                           Text(favMasjid!.tahajod,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.blue.shade800,
//                               )),
//                           const Text('')
//                         ])
//                             : const TableRow(children: [
//                           Text(''),
//                           Text(''),
//                           Text(''),
//                         ]),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           )),
//     );
//   }
// }
//
//
//
// class Clock extends StatelessWidget {
//   final Stream<DateTime> stream;
//
//   Clock({required this.stream});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DateTime>(
//       stream: stream,
//       builder: (context, snapshot) {
//         final dateTime = snapshot.data ?? DateTime.now();
//         final formattedTime = DateFormat.Hms().format(dateTime);
//         return Text(formattedTime,style: const TextStyle(fontSize: 20));
//       },
//     );
//   }
// }
