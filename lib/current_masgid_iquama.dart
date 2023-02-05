import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prayertime/audio_player/audio_player.dart';
import 'package:prayertime/class/current_masjid_location.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/quibla/loading.dart';
import 'package:prayertime/services/masjid_services.dart';

class CurrentMasjidIquama extends StatefulWidget {
  final MyMasjid? mainMasjid;
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
  String locale = 'ar';

  final HijriCalendar _today = HijriCalendar.now();

  void getTargetMasjid() async {
    target = LatLng(widget.mainMasjid!.positionMasjid.latitude,
        widget.mainMasjid!.positionMasjid.longitude);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    stream = Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
    return widget.isLoading
        ? LoadingIndicator()
        : widget.mainMasjid == null
            ? Container()
            : SizedBox(
                height: 500,
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

                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            (_today.toFormat("dd MMMM yyyy")).toString(),
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
                                const Text('Fajr',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                    )),
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
                                        widget.mainMasjid!.fajr.time.toString(),
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
                                    icon:
                                        const Icon(EvaIcons.volumeDownOutline))
                              ]),
                              TableRow(children: [
                                const Text('Lever de soleil',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
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
                                    icon:
                                    const Icon(EvaIcons.volumeDownOutline))
                              ]),
                              TableRow(children: [
                                const Text('Dhuhr',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
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
                                    : Text('+${widget.mainMasjid!.dhuhr.time}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue.shade800,
                                        )),
                                IconButton(
                                    onPressed: () {},
                                    icon:
                                        const Icon(EvaIcons.volumeDownOutline))
                              ]),
                              TableRow(children: [
                                const Text('Asr',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
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
                                        widget.mainMasjid!.asr.time.toString(),
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
                                    icon:
                                        const Icon(EvaIcons.volumeDownOutline))
                              ]),
                              TableRow(children: [
                                const Text('Maghrib',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
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
                                    icon:
                                        const Icon(EvaIcons.volumeDownOutline))
                              ]),
                              TableRow(children: [
                                const Text('Isha',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
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
                                        widget.mainMasjid!.fajr.time.toString(),
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
                                    icon:
                                        const Icon(EvaIcons.volumeDownOutline))
                              ]),
                              widget.mainMasjid!.existJoumoua
                                  ? TableRow(children: [
                                      const Text('Joumoua',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue,
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
                                      const Text('Aid',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue,
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
                              widget.mainMasjid!.existtAhajod
                                  ? TableRow(children: [
                                      const Text('Tahajod',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue,
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(widget.mainMasjid!.tahajod,
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
        return Text(formattedTime, style: const TextStyle(fontSize: 20));
      },
    );
  }
}
