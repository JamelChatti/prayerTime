import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/services/masjid_services.dart';

class ContainerTimeBeforeIqama extends StatefulWidget {
  final MyMasjid? mainMasjid;


  ContainerTimeBeforeIqama({Key? key,  required this.mainMasjid})
      : super(key: key);

  @override
  State<ContainerTimeBeforeIqama> createState() =>
      _ContainerTimeBeforeIqamaState();
}

class _ContainerTimeBeforeIqamaState extends State<ContainerTimeBeforeIqama> {
  final Stream<DateTime> stream =
      Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());

  Map<Prayer, DateTime> iqamas = {};
  bool isLoading = false;
  UtilsMasjid utils = UtilsMasjid();

  @override
  void initState() {
    super.initState();
    getIqamas();
  }
  getIqamas() async {
    setState(() {
      isLoading = true;
    });
    for (var salat in Prayer.values) {
      if (salat != Prayer.none && salat != Prayer.sunrise) {
        await MasjidService.getIqama(salat, widget.mainMasjid!)
            .then((value) => iqamas[salat] = value!);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
        isLoading
            ? Container()
            :  StreamBuilder<DateTime>(
                stream: stream,
                builder: (context, snapshot) {
                  final now = snapshot.data ?? DateTime.now();
                  PrayerTimes prayerTimes = PrayerTimesManager().prayerTimes;
                  Prayer salat = prayerTimes.currentPrayer();
                 // Prayer salat = Prayer.asr;

                  if (salat == Prayer.none && salat == Prayer.sunrise) {
                    return Container();
                  }
                  DateTime adhan = prayerTimes.timeForPrayer(salat)!;
                  if ((now.compareTo(adhan) >= 0) &&
                      (now.compareTo(iqamas[salat]!) <= 0)) {
                    var remainingSeconds =
                        utils.difference(now, iqamas[salat]!).inSeconds;

                    int minutes = remainingSeconds ~/ 60;
                    int seconds = remainingSeconds % 60;
                    String duration = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                    return Center(
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: ShapeDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: const StadiumBorder(
                                side: BorderSide(width: 2))),
                        child: Center(
                          child: Text(
                            duration,
                            style: const TextStyle(
                              fontSize: 30,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                });
  }
}
