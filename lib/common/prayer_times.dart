import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/common/globals.dart';

class PrayerTimesManager {
 // final myCoordinates = Coordinates(35.741884, 10.575);
  final params = CalculationMethod.karachi.getParameters();
  late final prayerTimes;
  PrayerTimesManager() {
    final Coordinates myCoordinates = Coordinates(latitude, longitude);
    prayerTimes = PrayerTimes.today(myCoordinates, params);
  }
  String get fajr {
    return DateFormat.Hm().format(prayerTimes.fajr).toString();
  }
  String get sunrise {
    return DateFormat.Hm().format(prayerTimes.sunrise).toString();
  }
  String get dhuhr {
    return DateFormat.Hm().format(prayerTimes.dhuhr).toString();
  }
  String get asr {
    return DateFormat.Hm().format(prayerTimes.asr).toString();
  }
  String get maghrib {
    return DateFormat.Hm().format(prayerTimes.maghrib).toString();
  }
  String get isha {
    return DateFormat.Hm().format(prayerTimes.isha).toString();
  }
}