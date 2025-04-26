import 'dart:async';
import 'dart:core';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/views/my_drawer_views/display_on_tv/timer_controller.dart';
import 'package:prayertime/common/widgets/loading.dart';
import 'package:wakelock/wakelock.dart';

class DisplayOnTV extends StatefulWidget {
  final MyMasjid? mainMasjid;
  bool isLoading;

  DisplayOnTV({Key? key, this.isLoading = false, required this.mainMasjid})
      : super(key: key);

  @override
  State<DisplayOnTV> createState() => _DisplayOnTVState();
}

class _DisplayOnTVState extends State<DisplayOnTV> {
  Stream<DateTime>? stream;
  PrayerTimesManager prayerTimesManager = PrayerTimesManager();
  static final f = DateFormat('dd-MM-yyyy');
  UtilsMasjid utils = UtilsMasjid();
  HijriCalendar now = HijriCalendar.now();
  String? month;
  Duration ishaDuration = const Duration();
  late Duration fajrDuration;
  late Duration dhuhrDuration;
  late Duration asrDuration;
  late Duration maghribDuration;
  Duration timeBeforeSalat = const Duration();

  @override
  void initState() {
    super.initState();
    stream = Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
    month = UtilsMasjid.getMonthHijriInArabic();

    getDuration();
    Wakelock.enable();
    //Get.put(TimerController());
  }

  @override
  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? LoadingIndicator()
        : widget.mainMasjid == null
            ? Container()
            : SizedBox(
                height: 500,
                child: Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: SingleChildScrollView(child: mySecondContainer()),
                ),
              );
  }

  Container myContainer(Duration duration) {
    return Container(
        width: 500,
        height: 70,
        color: Colors.black,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              displayDuration(duration),
              style: TextStyle(
                fontSize: 50,
                color: Colors.blue[100],
                decoration: TextDecoration.none,
              ),
            ),
          ],
        )));
  }

  String displayDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(3));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  int? convertDuration(Duration duration) {
    int convertedDuration = int.parse(
        ((duration.toString().replaceAll('.', '')).replaceAll(':', ''))
            .substring(0, 3));
    // print(convertedDuration.toString());
    return convertedDuration;
  }

  void getDuration() {
    if (widget.mainMasjid!.isha.fixed) {
      ishaDuration = utils.difference(
          DateTime.now(),
          utils.convertTime(
              durationToString(int.parse(widget.mainMasjid!.isha.time)))!);
      if (convertDuration(ishaDuration)! > 0 &&
          convertDuration(ishaDuration)! < 10) {
        timeBeforeSalat = const Duration(minutes: 10);
        setState(() {});
      }
    } else {
      //ishaDuration = utils.difference(DateTime.now(),utils.convertTime( prayerTimesManager.isha )! );
      ishaDuration = utils.difference(
          DateTime.now(),
          DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, DateTime.now().hour, 42));
      if (convertDuration(ishaDuration)! > 0 &&
          convertDuration(ishaDuration)! < 10) {
        timeBeforeSalat = ishaDuration;
        setState(() {});
      }
    }
    if (widget.mainMasjid!.fajr.fixed) {
      fajrDuration = utils.difference(
          DateTime.now(), utils.convertTime(widget.mainMasjid!.fajr.time)!);
      if (convertDuration(fajrDuration)! > 0 &&
          convertDuration(fajrDuration)! < 10) {
        timeBeforeSalat = const Duration(minutes: 10);
        setState(() {});
      }
    } else {
      fajrDuration = utils.difference(
          DateTime.now(), utils.convertTime(prayerTimesManager.fajr)!);
      if (convertDuration(fajrDuration)! > 0 &&
          convertDuration(fajrDuration)! < 10) {
        timeBeforeSalat = fajrDuration;
        setState(() {});
      }
    }
    if (widget.mainMasjid!.dhuhr.fixed) {
      dhuhrDuration = utils.difference(
          DateTime.now(), utils.convertTime(widget.mainMasjid!.dhuhr.time)!);
      if (convertDuration(dhuhrDuration)! > 0 &&
          convertDuration(dhuhrDuration)! < 10) {
        timeBeforeSalat = const Duration(minutes: 10);
        setState(() {});
      }
    } else {
      dhuhrDuration = utils.difference(
          DateTime.now(), utils.convertTime(prayerTimesManager.dhuhr)!);
      if (convertDuration(dhuhrDuration)! > 0 &&
          convertDuration(dhuhrDuration)! < 10) {
        timeBeforeSalat = dhuhrDuration;
        setState(() {});
      }
    }
    if (widget.mainMasjid!.asr.fixed) {
      asrDuration = utils.difference(
          DateTime.now(), utils.convertTime(widget.mainMasjid!.asr.time)!);
      if (convertDuration(asrDuration)! > 0 &&
          convertDuration(asrDuration)! < 10) {
        timeBeforeSalat = const Duration(minutes: 10);
        setState(() {});
      }
    } else {
      asrDuration = utils.difference(
          DateTime.now(), utils.convertTime(prayerTimesManager.asr)!);
      if (convertDuration(asrDuration)! > 0 &&
          convertDuration(asrDuration)! < 10) {
        timeBeforeSalat = asrDuration;
        setState(() {});
      }
    }
    if (widget.mainMasjid!.maghrib.fixed) {
      maghribDuration = utils.difference(
          DateTime.now(), utils.convertTime(widget.mainMasjid!.maghrib.time)!);
      if (convertDuration(maghribDuration)! > 0 &&
          convertDuration(maghribDuration)! < 10) {
        timeBeforeSalat = const Duration(minutes: 10);
        setState(() {});
      }
    } else {
      maghribDuration = utils.difference(
          DateTime.now(), utils.convertTime(prayerTimesManager.maghrib)!);
      if (convertDuration(maghribDuration)! > 0 &&
          convertDuration(maghribDuration)! < 10) {
        timeBeforeSalat = maghribDuration;
        setState(() {});
      }
    }
  }

  Container mySecondContainer() {
    return Container(
      width: 500,
      height: 700,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.mainMasjid!.name,
            style: TextStyle(
              fontSize: 10,
              color: Colors.green[300],
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  // (_today.toFormat("dd MMMM yyyy")).toString(),
                  '${now.hDay.toString().padLeft(2, '0')} ${month} ${now.hYear.toString()}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green[300],
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              const SizedBox(
                width: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  f.format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green[300],
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          Clock(
            stream: stream!,
          ),
          ContainerTimeBeforeIqama(mainMasjid: widget.mainMasjid),
          // ?myContainer(timeBeforSalat):Container(),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,

              // border: TableBorder.all(color: Colors.black),
              children: [
                const TableRow(children: [
                  Text('',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                      )),
                  Text('الفجر',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                      )),
                  Text('الشروق',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                      )),
                  Text('الظهر',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                      )),
                  Text('العصر',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                      )),
                  Text('المغرب',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                      )),
                  Text('العشاء',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                      )),
                ]),
                TableRow(children: [
                  const Text('الاذان',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        decoration: TextDecoration.none,
                      )),
                  Text(prayerTimesManager.fajr,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        decoration: TextDecoration.none,
                      )),
                  Text(prayerTimesManager.sunrise,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        decoration: TextDecoration.none,
                      )),
                  Text(prayerTimesManager.dhuhr,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        decoration: TextDecoration.none,
                      )),
                  Text(prayerTimesManager.asr,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        decoration: TextDecoration.none,
                      )),
                  Text(prayerTimesManager.maghrib,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        decoration: TextDecoration.none,
                      )),
                  Text(prayerTimesManager.isha,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        decoration: TextDecoration.none,
                      )),
                ]),
                TableRow(children: [
                  const Text('الاقامة',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        decoration: TextDecoration.none,
                      )),
                  widget.mainMasjid!.fajr.fixed
                      ? Text(widget.mainMasjid!.fajr.time.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                          ))
                      : Text('+${widget.mainMasjid!.fajr.time}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                          )),
                  Text(''.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        decoration: TextDecoration.none,
                      )),
                  widget.mainMasjid!.dhuhr.fixed
                      ? Text(widget.mainMasjid!.dhuhr.time.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                          ))
                      : Text('+${widget.mainMasjid!.dhuhr.time}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                          )),
                  widget.mainMasjid!.asr.fixed
                      ? Text(widget.mainMasjid!.asr.time.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                          ))
                      : Text('+${widget.mainMasjid!.asr.time}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                          )),
                  widget.mainMasjid!.maghrib.fixed
                      ? Text(widget.mainMasjid!.maghrib.time.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                          ))
                      : Text('+${widget.mainMasjid!.maghrib.time}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                          )),
                  widget.mainMasjid!.isha.fixed
                      ? Text(widget.mainMasjid!.isha.time.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                          ))
                      : Text('+${widget.mainMasjid!.isha.time}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                          )),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
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
        return Text(formattedTime,
            style: TextStyle(
                fontSize: 10,
                decoration: TextDecoration.none,
                color: Colors.green[300]));
      },
    );
  }
}
