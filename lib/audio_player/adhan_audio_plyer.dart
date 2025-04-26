import 'dart:async';
import 'dart:isolate';

import 'package:adhan/adhan.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:prayertime/common/prayer_times.dart';
import '../common/globals.dart';

class AudioPrayerAdhan {
  late AudioPlayer audioPlayer;
  late Timer _timer;
  PrayerTimesManager prayerTimesManager = PrayerTimesManager();

  void configurePrayerTimes() {

    DateTime now = DateTime.now();
    Prayer nextPrayer = prayerTimesManager.prayerTimes.nextPrayer();
    // Prayer nextPrayer = prayerTimesManager.prayerTimes
    //     .nextPrayerByDateTime(DateTime(now.year, now.month, now.day, 22, 41));
    DateTime? nextPrayerTime;
    if (nextPrayer == Prayer.none) {
      nextPrayerTime = prayerTimesManager.prayerTimesTomorrow.fajr;
    } else {
      nextPrayerTime = prayerTimesManager.prayerTimes.timeForPrayer(nextPrayer)!;
    }
    //nextPrayerTime= DateTime(now.year, now.month, now.day, now.hour, 59, 0,0);


  _timer = Timer(nextPrayerTime.difference(now), playAdhan);
    Timer(Duration(seconds: 20), () {
      configurePrayerTimes();

    });



    // if (now.isBefore(prayerTimesManager.prayerTimes.fajr)) {
    //   durationUntilNextPrayer =
    //       prayerTimesManager.prayerTimes.fajr.difference(now);
    // } else if (now.isBefore(prayerTimesManager.prayerTimes.dhuhr)) {
    //   durationUntilNextPrayer =
    //       prayerTimesManager.prayerTimes.dhuhr.difference(now);
    // } else if (now.isBefore(prayerTimesManager.prayerTimes.asr)) {
    //   durationUntilNextPrayer =
    //       prayerTimesManager.prayerTimes.asr.difference(now);
    // } else if (now
    //     .isBefore(DateTime(now.year, now.month, now.day, now.hour, 1))) {
    //   durationUntilNextPrayer =
    //       DateTime(now.year, now.month, now.day, now.hour, 1).difference(now);
    // } else if (now.isBefore(prayerTimesManager.prayerTimes.maghrib)) {
    //   durationUntilNextPrayer =
    //       prayerTimesManager.prayerTimes.maghrib.difference(now);
    // } else if (now.isBefore(prayerTimesManager.prayerTimes.isha)) {
    //   durationUntilNextPrayer =
    //       prayerTimesManager.prayerTimes.isha.difference(now);
    // } else {
    //   // No prayer for today, you can implement appropriate logic here
    //   return;
    // }
    //
    // // Start the timer to play the adhan when the next prayer arrives
    // _timer = Timer(durationUntilNextPrayer, playAdhan);
  }

  void playAdhan() async {
    // Play the adhan audio here
    audioPlayer = AudioPlayer();
    await audioPlayer.play(
      AssetSource('azan6.mp3'),
      volume: 20,
    );
    configurePrayerTimes();
    // You can also display a notification or perform other actions when the adhan is played
  }

  @override
  void dispose() {
    // Make sure to release the audio resources when the widget is removed
    audioPlayer.stop();
    audioPlayer.dispose();
    _timer.cancel();
  }

  void timerIsolate(SendPort mainToIsolatePort) {
   // Timer? _timer;

    void playAdhan() async {
      // Play the adhan audio here
      audioPlayer = AudioPlayer();
      await audioPlayer.play(
        AssetSource('azan6.mp3'),
        volume: 20,
      );
      configurePrayerTimes();
      // You can also display a notification or perform other actions when the adhan is played
    }

    mainToIsolatePort.send('Isolate ready');

    // Receive messages from the main isolate
    ReceivePort isolateToMainPort = ReceivePort();
    mainToIsolatePort.send(isolateToMainPort.sendPort);

    DateTime now = DateTime.now();
    Prayer nextPrayer = prayerTimesManager.prayerTimes.nextPrayer();
    // Prayer nextPrayer = prayerTimesManager.prayerTimes
    //     .nextPrayerByDateTime(DateTime(now.year, now.month, now.day, 22, 41));
    DateTime? nextPrayerTime;
    if (nextPrayer == Prayer.none) {
      nextPrayerTime = prayerTimesManager.prayerTimesTomorrow.fajr;
    } else {
      nextPrayerTime = prayerTimesManager.prayerTimes.timeForPrayer(nextPrayer)!;
    }
    //nextPrayerTime= DateTime(now.year, now.month, now.day, now.hour, 59, 0,0);


    isolateToMainPort.listen((message) {
      if (message is DateTime) {
        final now = DateTime.now();
        _timer = Timer(nextPrayerTime!.difference(now), playAdhan);
        }
    });
  }




}
