import 'dart:ui' as ui;

import 'package:adhan/adhan.dart';
import 'package:adhan/src/coordinates.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:prayertime/audio_player/adhan_audio_plyer.dart';
import 'package:prayertime/common/HiveBoxesManager.dart';
import 'package:prayertime/common/constants.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/services/masjid_services.dart';
import 'package:prayertime/views/tab_views/current_masjid//map.dart';

class CurrentMasjidIquama extends StatefulWidget {
  const CurrentMasjidIquama({Key? key}) : super(key: key);

  @override
  State<CurrentMasjidIquama> createState() => _CurrentMasjidIquamaState();
}

class _CurrentMasjidIquamaState extends State<CurrentMasjidIquama> {
  Stream<DateTime>? stream;

  MasjidService masjidService = MasjidService();
  PrayerTimesManager prayerTimesManager = PrayerTimesManager();
  final HiveBoxesManager _hiveBoxesManager = HiveBoxesManager();
  AudioPrayerAdhan audioPrayerAdhan = AudioPrayerAdhan();
  LatLng? target;
  static final f = DateFormat('dd-MM-yyyy');
  DateComponents currentDate = DateComponents.from(DateTime.now());
  bool volume = false;
  HijriCalendar now = HijriCalendar.now();
  String? month;
  final Coordinates coordinates = Coordinates(
      mainMasjid!.positionMasjid.latitude,
      mainMasjid!.positionMasjid.longitude);

  void getTargetMasjid() async {
    target = LatLng(mainMasjid!.positionMasjid.latitude,
        mainMasjid!.positionMasjid.longitude);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getTargetMasjid();
    month = UtilsMasjid.getMonthHijriInArabic();
   // audioPrayerAdhan.configurePrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    if (mainMasjid != null) {
      stream =
          Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
    }
    return mainMasjid == null
        ? const Center(
            child: Text(
                textAlign: TextAlign.center,
                "Please choose favorite masjids to display iqama times."))
        : mainMasjid == null
            ? Container()
            : Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.cyan,
                            child: IconButton(
                                onPressed: () {
                                  getTargetMasjid();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                          builder: (context) =>
                                              MyMap(target: target!)));
                                },
                                icon: const Icon(
                                  Icons.edit_location,
                                  color: Colors.red,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: [
                          mainMasjidDropdown(),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              '${now.hDay.toString().padLeft(2, '0')} ${month} ${now.hYear.toString()}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              f.format(DateTime.now()),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Clock(
                            stream: stream!,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FractionColumnWidth(.30),
                                1: FractionColumnWidth(.25),
                                2: FractionColumnWidth(.25),
                                // 3: FractionColumnWidth(.30),
                              },
                              // border: TableBorder.all(color: Colors.black),
                              children: [
                                TableRow(children: [
                                  Container(child: text('الفجر')),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: text(prayerTimesManager.fajr),
                                  ),
                                  mainMasjid!.fajr.fixed
                                      ? text(mainMasjid!.fajr.time.toString())
                                      : text('+${mainMasjid!.fajr.time}'),
                                  IconButton(
                                    onPressed: () {
                                      // PrayerAudio().play('https://www.islamicfinder.org/wp-content/uploads/adhan/adhan.mp3');
                                    },
                                    icon: volume
                                        ? const Icon(EvaIcons.volumeDownOutline)
                                        : const Icon(EvaIcons.volumeOff),
                                  )
                                ]),
                                TableRow(children: [
                                  text('الشروق'),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: text(prayerTimesManager.sunrise),
                                  ),
                                  const Text(''),
                                  IconButton(
                                      onPressed: () {
                                        // PrayerAudio().play('https://www.islamicfinder.org/wp-content/uploads/adhan/adhan.stre');
                                      },
                                      icon: const Icon(
                                          EvaIcons.volumeDownOutline))
                                ]),
                                TableRow(children: [
                                  text('الظهر'),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: text(prayerTimesManager.dhuhr),
                                  ),
                                  mainMasjid!.dhuhr.fixed
                                      ? text(mainMasjid!.dhuhr.time.toString())
                                      : text('+${mainMasjid!.dhuhr.time}'),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          EvaIcons.volumeDownOutline))
                                ]),
                                TableRow(children: [
                                  text('العصر'),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: text(prayerTimesManager.asr),
                                  ),
                                  mainMasjid!.asr.fixed
                                      ? text(mainMasjid!.asr.time.toString())
                                      : text('+${mainMasjid!.asr.time}'),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          EvaIcons.volumeDownOutline))
                                ]),
                                TableRow(children: [
                                  text('المغرب'),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: text(prayerTimesManager.maghrib),
                                  ),
                                  mainMasjid!.maghrib.fixed
                                      ? text(
                                          mainMasjid!.maghrib.time.toString())
                                      : Text('+${mainMasjid!.maghrib.time}'),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          EvaIcons.volumeDownOutline))
                                ]),
                                TableRow(children: [
                                  text('العشاء'),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: text(prayerTimesManager.isha),
                                  ),
                                  mainMasjid!.isha.fixed
                                      ? text(mainMasjid!.fajr.time.toString())
                                      : text('+${mainMasjid!.isha.time}'),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          EvaIcons.volumeDownOutline))
                                ]),
                                mainMasjid!.existJoumoua
                                    ? TableRow(children: [
                                        text('الجمعة'),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: text(
                                              mainMasjid!.joumoua.toString()),
                                        ),
                                        const Text(''),
                                        const Text(''),
                                      ])
                                    : const TableRow(children: [
                                        Text(''),
                                        Text(''),
                                        Text(''),
                                        Text(''),
                                      ]),
                                mainMasjid!.existAid
                                    ? TableRow(children: [
                                        text('العيد'),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: text(mainMasjid!.aid),
                                        ),
                                        const Text(''),
                                        const Text(''),
                                      ])
                                    : const TableRow(children: [
                                        Text(''),
                                        Text(''),
                                        Text(''),
                                        Text(''),
                                      ]),
                                mainMasjid!.existTahajod
                                    ? TableRow(children: [
                                        text('Tahajod'),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: text(mainMasjid!.tahajod),
                                        ),
                                        const Text(''),
                                        const Text(''),
                                      ])
                                    : const TableRow(children: [
                                        Text(''),
                                        Text(''),
                                        Text(''),
                                        Text(''),
                                      ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                ),
              );
  }

  void updateMainMasjid(MyMasjid newMainMasjid) {
    //update globals
    _hiveBoxesManager.updateMainMasjid(newMainMasjid);
    //update locals
    prayerTimesManager = PrayerTimesManager();
  }

  Widget mainMasjidDropdown() {
    Widget dropdown = mainMasjid != null
        ? DropdownButton<MyMasjid>(
            value: mainMasjid == null
                ? null
                : myMasjids
                    .firstWhere((element) => mainMasjid!.id == element.id),
            onChanged: (newMainMasjid) {
              if (newMainMasjid != null) {
                updateMainMasjid(newMainMasjid);
                setState(() {
                  mainMasjid;
                });
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
    return dropdown;
  }

  Text text(String salat) {
    return Text(salat,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
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
        return Text(formattedTime, style: const TextStyle(fontSize: 20));
      },
    );
  }
}
