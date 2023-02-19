

import 'dart:async';
import 'dart:core';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/quibla/loading.dart';

class DisplayOnTV extends StatefulWidget {
  final MyMasjid? mainMasjid;
  bool isLoading;

  DisplayOnTV(
      {Key? key, this.isLoading = false, required this.mainMasjid})
      : super(key: key);

  @override
  State<DisplayOnTV> createState() => _DisplayOnTVState();
}

class _DisplayOnTVState extends State<DisplayOnTV> {
  Stream<DateTime>? stream;
  PrayerTimesManager prayerTimesManager = PrayerTimesManager();
  LatLng? target;
  static final f = DateFormat('dd-MM-yyyy');
  String locale = 'ar';
  Duration tenMinutes = const Duration(minutes: 10);
  Duration zeroMinutes = const Duration(minutes: 0);
  bool tenMn = false ;
  Timer? _timer;
  int _startSec = 5;
  int _startMn = 0;
  DateTime current = DateTime.now();

  final HijriCalendar _today = HijriCalendar.now();

  String sTime ='10';

  void startTimerSec() {
    const oneSec = Duration(seconds: 1);
    _timer =  Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_startSec == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _startSec--;
          });
        }
      },
    );
  }
  void startTimerMn() {
    const oneSec = Duration(seconds: 2);
    _timer =  Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_startMn == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _startMn--;
            if (_startMn==0) {
              startTimerSec();
            }
          });
        }
      },
    );
  }



  @override
  void initState() {
    super.initState();
    stream = Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
    tenMinute();

    //sTime=widget.mainMasjid!.asr.time.toString();
    _startMn = 9;
    //int.parse(sTime);
    print(sTime);
    if(mounted)
      startTimerMn();


  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return widget.isLoading
        ? LoadingIndicator()
        : widget.mainMasjid == null
        ? Container()
        : SizedBox(
      height: 500,
      child: Directionality(
        textDirection:ui.TextDirection.rtl,

        child: SingleChildScrollView(
            child: tenMn? myContainer()
                :mySecondContainer()

        ),
      ),
    );
  }

  DateTime? convertTime(String t) {
    TimeOfDay time = TimeOfDay(hour:int.parse(t.split(":")[0]),minute: int.parse(t.split(":")[1]));
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  Duration difference(DateTime start, DateTime end) {
    return end.difference(start);}

  Container myContainer(){
    return Container(
        width: 500,
        height: 700,
        color: Colors.black,
        child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _startMn!=0?
            Text("$_startMn",style:  TextStyle(fontSize: 200,color: Colors.blue[100],
              decoration: TextDecoration.none,
            ),):Container(),
            _startSec!=0 && _startMn==0?
            Text("$_startSec",style:  TextStyle(fontSize: 200,color:Colors.blue[100],
              decoration: TextDecoration.none,
            ))
                :_startMn==0? Text('سبحان الله',style:  TextStyle(fontSize: 70,color:Colors.blue[100],
              decoration: TextDecoration.none,
            )):Container()


          ],
        )));
  }

  String durationToString(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }





  void tenMinute(){
    Stream timer = Stream.periodic( const Duration(seconds: 1), (i){
      current = current.add(const Duration(seconds: 1));
      return current;
    });
    timer.listen((data) {
      Duration ishaDuration;
      widget.mainMasjid!.isha.fixed ?
      ishaDuration = difference(data, convertTime(
          durationToString(int.parse(widget.mainMasjid!.isha.time)))!)
          : ishaDuration = difference(data,convertTime( prayerTimesManager.isha )! );
      Duration fajrDuration;
      widget.mainMasjid!.fajr.fixed ?
      fajrDuration =
          difference(data, convertTime(widget.mainMasjid!.fajr.time)!)
          : fajrDuration = difference(data, convertTime( prayerTimesManager.fajr )!);
      Duration dhuhrDuration;
      widget.mainMasjid!.dhuhr.fixed ?
      dhuhrDuration =
          difference(data, convertTime(widget.mainMasjid!.dhuhr.time)!)
          : dhuhrDuration = difference(data, convertTime( prayerTimesManager.dhuhr )!);
      Duration asrDuration;
      widget.mainMasjid!.asr.fixed ?
      asrDuration =
          difference(data, convertTime(widget.mainMasjid!.asr.time)!)
          : asrDuration = difference(data,DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,21));
      // : asrDuration = difference(data, convertTime( prayerTimesManager.asr )!);
      Duration maghribDuration;
      widget.mainMasjid!.maghrib.fixed ?
      maghribDuration =
          difference(data, convertTime(widget.mainMasjid!.maghrib.time)!)
          : maghribDuration = difference(data, convertTime( prayerTimesManager.maghrib )!);

      if ((ishaDuration > zeroMinutes && ishaDuration < tenMinutes) ||
          (fajrDuration > zeroMinutes && fajrDuration < tenMinutes) ||
          (dhuhrDuration > zeroMinutes && dhuhrDuration < tenMinutes) ||
          (asrDuration > zeroMinutes && asrDuration < tenMinutes) ||
          (maghribDuration > zeroMinutes && maghribDuration < tenMinutes)) {
        tenMn = true;
        setState(() {

        });
      } else {
        tenMn = false;


      }
    });
  }


  Container mySecondContainer(){
    return Container(
      width: 500,
      height: 700,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.mainMasjid!.name, style: const TextStyle(fontSize: 25,decoration: TextDecoration.none,),),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  (_today.toFormat("dd MMMM yyyy")).toString(),
                  style: const TextStyle(fontSize: 25,decoration: TextDecoration.none,),
                ),
              ),
              const SizedBox(width: 80,),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  f.format(DateTime.now()),
                  style: const TextStyle(fontSize: 25,
                    decoration: TextDecoration.none,),
                ),
              ),
            ],
          ),
          Clock(stream: stream!),

          Padding(
            padding:  const EdgeInsets.only(left: 10.0),
            child: Table(
              defaultVerticalAlignment:
              TableCellVerticalAlignment.middle,

              // border: TableBorder.all(color: Colors.black),
              children:  [
                const TableRow(children: [
                  Text('',style: TextStyle(
                    fontSize: 25,
                    color: Colors.blue,
                    decoration: TextDecoration.none,
                  )),
                  Text('الفجر',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue,
                        decoration: TextDecoration.none,
                      )),
                  Text('الشروق',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue,
                        decoration: TextDecoration.none,
                      )),
                  Text('الظهر',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue,
                        decoration: TextDecoration.none,
                      )),
                  Text('العصر',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue,
                        decoration: TextDecoration.none,
                      )),
                  Text('المغرب',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue,
                        decoration: TextDecoration.none,
                      )),
                  Text('العشاء',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue,
                        decoration: TextDecoration.none,
                      )),


                ]),
                TableRow(children: [
                  Text('الاذان',style: TextStyle(
                    fontSize: 25,
                    color: Colors.blue.shade800,
                    decoration: TextDecoration.none,
                  )),
                  Text(prayerTimesManager.fajr,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      )),
                  Text(prayerTimesManager.sunrise,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      )),

                  Text(prayerTimesManager.dhuhr,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      )),
                  Text(prayerTimesManager.asr,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      )),
                  Text(prayerTimesManager.maghrib,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      )),
                  Text(prayerTimesManager.isha,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      )),


                ]),
                TableRow(children: [
                  Text('الاقامة',style: TextStyle(
                    fontSize: 25,
                    color: Colors.blue.shade800,
                    decoration: TextDecoration.none,
                  )),
                  widget.mainMasjid!.fajr.fixed
                      ? Text(
                      widget.mainMasjid!.fajr.time
                          .toString(),
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      ))
                      : Text('+${widget.mainMasjid!.fajr.time}',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      )),

                  Text(
                      ''
                          .toString(),
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      )),
                  widget.mainMasjid!.dhuhr.fixed
                      ? Text(
                      widget.mainMasjid!.dhuhr.time
                          .toString(),
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      ))
                      : Text('+${widget.mainMasjid!.dhuhr.time}',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      )),
                  widget.mainMasjid!.asr.fixed
                      ? Text(
                      widget.mainMasjid!.asr.time
                          .toString(),
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      ))
                      : Text('+${widget.mainMasjid!.asr.time}',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      )),
                  widget.mainMasjid!.maghrib.fixed
                      ? Text(
                      widget.mainMasjid!.maghrib.time
                          .toString(),
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      ))
                      : Text('+${widget.mainMasjid!.maghrib.time}',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      )),
                  widget.mainMasjid!.isha.fixed
                      ? Text(
                      widget.mainMasjid!.isha.time
                          .toString(),
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      ))
                      : Text('+${widget.mainMasjid!.isha.time}',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.none,
                      )),
                ]),



              ],
            ),

          ),
        ],
      ),);
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
        return Text(formattedTime, style: const TextStyle(fontSize: 25,decoration: TextDecoration.none,));
      },
    );
  }

}


