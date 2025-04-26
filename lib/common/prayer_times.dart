import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:prayertime/common/constants.dart';
import 'package:prayertime/common/globals.dart';

class PrayerTimesManager {
  late final PrayerTimes prayerTimes;
  late final PrayerTimes prayerTimesTomorrow;

  PrayerTimesManager() {
    final Coordinates myCoordinates;
    if (mainMasjid != null) {
      myCoordinates = Coordinates(mainMasjid!.positionMasjid.latitude,
          mainMasjid!.positionMasjid.longitude);
    } else {
      myCoordinates = Coordinates(mekkaLatitude, mekkaLongitude);
    }
    paramMethode.adjustments=PrayerAdjustments(fajr: -1,sunrise: -1,dhuhr: 6,maghrib: 2,isha: 1);
    paramMethode.madhab = Madhab.shafi;
    prayerTimes = PrayerTimes.today(myCoordinates, paramMethode);
    DateTime now = DateTime.now();
    prayerTimesTomorrow = PrayerTimes(myCoordinates, DateComponents.from(DateTime(now.year, now.month, now.day + 1)),paramMethode);
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
