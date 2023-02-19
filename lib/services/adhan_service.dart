//
// import 'package:adhan/adhan.dart';
// import 'package:intl/intl.dart';
//
// class AdhanService {
//   void getTimePrayer(double latitude, double longitude){
//     print('Kushtia Prayer Times');
//     params.madhab = Madhab.hanafi;
//     final prayerTimes = PrayerTimes.today(myCoordinates, params);
//
//     print(
//         "---Today's Prayer Times in Your Local Timezone(${prayerTimes.fajr.timeZoneName})---");
//     print(DateFormat.jm().format(prayerTimes.fajr));
//     print(DateFormat.jm().format(prayerTimes.sunrise));
//     print(DateFormat.jm().format(prayerTimes.dhuhr));
//     print(DateFormat.jm().format(prayerTimes.asr));
//     print(DateFormat.jm().format(prayerTimes.maghrib));
//     print(DateFormat.jm().format(prayerTimes.isha));
//
//     print('---');
//
//     // Custom Timezone Usage. (Most of you won't need this).
//     print('NewYork Prayer Times');
//
//     nyParams.madhab = Madhab.hanafi;
//
//     final nyPrayerTimes =
//     PrayerTimes(newYork, nyDate, nyParams, utcOffset: nyUtcOffset);
//
//     print(nyPrayerTimes.fajr.timeZoneName);
//     print(DateFormat.jm().format(nyPrayerTimes.fajr));
//     print(DateFormat.jm().format(nyPrayerTimes.sunrise));
//     print(DateFormat.jm().format(nyPrayerTimes.dhuhr));
//     print(DateFormat.jm().format(nyPrayerTimes.asr));
//     print(DateFormat.jm().format(nyPrayerTimes.maghrib));
//     print(DateFormat.jm().format(nyPrayerTimes.isha));
//   }
//
//   }
//
//   final myCoordinates =
//   Coordinates(23.9088, 89.1220); // Replace with your own location lat, lng.
//   final params = CalculationMethod.karachi.getParameters();
//
//
//
//   final newYork = Coordinates(35.7750, -78.6336);
//   final nyUtcOffset = Duration(hours: -4);
//   final nyDate = DateComponents(2015, 7, 12);
//   final nyParams = CalculationMethod.north_america.getParameters();
//
//

import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/common/globals.dart';

class PrayerTimesMasjid {
  // final myCoordinates = Coordinates(35.741884, 10.575);
  final params = CalculationMethod.karachi.getParameters();
  late final prayerTimes;
  PrayerTimesMasjid(double latitudeMasjid, double longitudeMasjid) {
    final Coordinates myCoordinates = Coordinates(latitudeMasjid, longitudeMasjid);
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