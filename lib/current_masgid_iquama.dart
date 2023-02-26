import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:prayertime/class/current_masjid_location.dart';
import 'package:prayertime/class/hive_masjid.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/quibla/loading.dart';
import 'package:prayertime/services/adhan_service.dart';
import 'package:prayertime/services/masjid_services.dart';
import 'dart:ui' as ui;

class CurrentMasjidIquama extends StatefulWidget {
  late final MyMasjid? mainMasjid;
  bool isLoading;

  CurrentMasjidIquama(
      {Key? key, this.isLoading = false, required this.mainMasjid})
      : super(key: key);

  @override
  State<CurrentMasjidIquama> createState() => _CurrentMasjidIquamaState();
}

class _CurrentMasjidIquamaState extends State<CurrentMasjidIquama> {
  Stream<DateTime>? stream;
  MasjidService masjidService = MasjidService();
  PrayerTimesManager prayerTimesManager = PrayerTimesManager();
  LatLng? target;
  static final f = DateFormat('dd-MM-yyyy');
  var mainMasjidsBox = Hive.box<HiveMasjid>('mainMasjid');
  List<HiveMasjid> myMasjids = [];

  var myMasjidsBox = Hive.box<HiveMasjid>('myMasjids');

  HijriCalendar now = HijriCalendar.now();
  String? month;

  void getMainMasjid(HiveMasjid? hiveMainMasjid) {
    if (widget.mainMasjid == null ||
        hiveMainMasjid == null ||
        hiveMainMasjid.id != widget.mainMasjid!.id) {
      widget.mainMasjid = null;
      setState(() {
        widget.isLoading = true;
      });
      if (hiveMainMasjid != null) {
        MasjidService.getMasjidWithId(hiveMainMasjid.id).then((value) {
          widget.mainMasjid = value;
          setState(() {
            widget.isLoading = false;
          });
        });
      } else {
        setState(() {
          widget.isLoading = false;
        });
      }
    }
  }

  void getTargetMasjid() async {
    target = LatLng(widget.mainMasjid!.positionMasjid.latitude,
        widget.mainMasjid!.positionMasjid.longitude);
    setState(() {});
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
  void initState() {
    super.initState();
    getMonthHijriInArabic();
    myMasjids = myMasjidsBox.values.toList();
    myMasjids = myMasjidsBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    HiveMasjid masjid = mainMasjidsBox.values.elementAt(0);
    PrayerTimesMasjid prayerTimesManager = PrayerTimesMasjid(masjid.latitude, masjid.longitude);
    stream = Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
    return widget.isLoading
        ? LoadingIndicator()
        : widget.mainMasjid == null
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
                          // Text(
                          //   widget.mainMasjid!.name,
                          //   style: TextStyle(
                          //     fontSize: 15,
                          //     color: Colors.blue.shade800,
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 40,
                          // ),
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
                          // Padding(
                          //   padding: const EdgeInsets.all(5.0),
                          //   child: Column(
                          //     children: [
                          //       Text('Ville: ${widget.mainMasjid!.city} '),
                          //       Text( ' ${widget.mainMasjid!.positionMasjid.latitude.toStringAsFixed(5)},'
                          //           ' ${widget.mainMasjid!.positionMasjid.longitude.toStringAsFixed(5)} '),
                          //     ],
                          //   ),
                          // ),
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
                                  const Text('الفجر',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(prayerTimesManager.fajr,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue.shade800,
                                        )),
                                  ),
                                  widget.mainMasjid!.fajr.fixed
                                      ? Text(
                                          widget.mainMasjid!.fajr.time
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue.shade800,
                                          ))
                                      : Text('+${widget.mainMasjid!.fajr.time}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue.shade800,
                                          )),
                                  IconButton(
                                      onPressed: () {
                                        // PrayerAudio().play('https://www.islamicfinder.org/wp-content/uploads/adhan/adhan.mp3');
                                      },
                                      icon: const Icon(
                                          EvaIcons.volumeDownOutline))
                                ]),
                                TableRow(children: [
                                  const Text('الشروق',
                                      style: TextStyle(
                                        fontSize: 15,fontWeight: FontWeight.bold
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(prayerTimesManager.sunrise,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue.shade800,
                                        )),
                                  ),
                                  Text(''),
                                  IconButton(
                                      onPressed: () {
                                        // PrayerAudio().play('https://www.islamicfinder.org/wp-content/uploads/adhan/adhan.mp3');
                                      },
                                      icon: const Icon(
                                          EvaIcons.volumeDownOutline))
                                ]),
                                TableRow(children: [
                                  const Text('الظهر',
                                      style: TextStyle(
                                        fontSize: 15,fontWeight: FontWeight.bold
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(prayerTimesManager.dhuhr,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue.shade800,
                                        )),
                                  ),
                                  widget.mainMasjid!.dhuhr.fixed
                                      ? Text(
                                          widget.mainMasjid!.dhuhr.time
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue.shade800,
                                          ))
                                      : Text(
                                          '+${widget.mainMasjid!.dhuhr.time}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue.shade800,
                                          )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          EvaIcons.volumeDownOutline))
                                ]),
                                TableRow(children: [
                                  const Text('العصر',
                                      style: TextStyle(
                                        fontSize: 15,fontWeight: FontWeight.bold
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(prayerTimesManager.asr,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue.shade800,
                                        )),
                                  ),
                                  widget.mainMasjid!.asr.fixed
                                      ? Text(
                                          widget.mainMasjid!.asr.time
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue.shade800,
                                          ))
                                      : Text('+${widget.mainMasjid!.asr.time}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue.shade800,
                                          )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          EvaIcons.volumeDownOutline))
                                ]),
                                TableRow(children: [
                                  const Text('المغرب',
                                      style: TextStyle(
                                        fontSize: 15,fontWeight: FontWeight.bold
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(prayerTimesManager.maghrib,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue.shade800,
                                        )),
                                  ),
                                  widget.mainMasjid!.maghrib.fixed
                                      ? Text(
                                          widget.mainMasjid!.maghrib.time
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue.shade800,
                                          ))
                                      : Text(
                                          '+${widget.mainMasjid!.maghrib.time}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue.shade800,
                                          )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          EvaIcons.volumeDownOutline))
                                ]),
                                TableRow(children: [
                                  const Text('العشاء',
                                      style: TextStyle(
                                        fontSize: 15,fontWeight: FontWeight.bold
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(prayerTimesManager.isha,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue.shade800,
                                        )),
                                  ),
                                  widget.mainMasjid!.isha.fixed
                                      ? Text(
                                          widget.mainMasjid!.fajr.time
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue.shade800,
                                          ))
                                      : Text('+${widget.mainMasjid!.isha.time}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue.shade800,
                                          )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          EvaIcons.volumeDownOutline))
                                ]),
                                widget.mainMasjid!.existJoumoua
                                    ? TableRow(children: [
                                        const Text('الجمعة',
                                            style: TextStyle(
                                              fontSize: 15,fontWeight: FontWeight.bold
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                              widget.mainMasjid!.joumoua
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.blue.shade800,
                                              )),
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
                                widget.mainMasjid!.existAid
                                    ? TableRow(children: [
                                        const Text('العيد',
                                            style: TextStyle(
                                              fontSize: 15,fontWeight: FontWeight.bold
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(widget.mainMasjid!.aid,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.blue.shade800,
                                              )),
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
                                widget.mainMasjid!.existTahajod
                                    ? TableRow(children: [
                                        const Text('Tahajod',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blue,
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child:
                                              Text(widget.mainMasjid!.tahajod,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.blue.shade800,
                                                  )),
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
  Widget mainMasjidDropdown() {
    Widget dropdown = widget.isLoading
        ? LoadingIndicator()
        : widget.mainMasjid != null
        ? DropdownButton<HiveMasjid>(
      value: widget.mainMasjid == null
          ? null
          :
      myMasjids
          .firstWhere((element) => widget.mainMasjid!.id == element.id),
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
    return dropdown;
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
