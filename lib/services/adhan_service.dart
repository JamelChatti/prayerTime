
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:prayertime/common/constants.dart';

class PrayerTimesMasjid {
  // final myCoordinates = Coordinates(35.741884, 10.575);
  //final params = CalculationMethod.karachi.getParameters();
  late final prayerTimes;
  PrayerTimesMasjid(double latitudeMasjid, double longitudeMasjid) {
    final Coordinates myCoordinates = Coordinates(latitudeMasjid, longitudeMasjid);
    prayerTimes = PrayerTimes.today(myCoordinates, paramMethode);
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