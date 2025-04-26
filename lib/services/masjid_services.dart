import 'package:adhan/adhan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:prayertime/class/hive_masjid.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/common/utils.dart';

class MasjidService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  List<MyMasjid> masjids = [];
  var mainMasjidsBox = Hive.box<HiveMasjid>('mainMasjid');

  MyMasjid? mainMasjid;
  static Future<MyMasjid?> getMasjidWithId(String id) async {
    MyMasjid? masjid;

    await _firestore.collection("masjids").doc(id).get().then((ds) {
      if (ds.exists) {
        //String usertype
        masjid = MyMasjid.fromDocument(ds);
      }
    });
    return masjid;
  }

  static Future<MyMasjid?> getMasjidWithName(String name) async {
    MyMasjid? masjid;

    await _firestore
        .collection("masjids")
        .where("name", isEqualTo: name)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((result) {
        masjid = MyMasjid.fromDocument(result);
      });
    });
    return masjid;
  }

  static Future<bool> registrationComplete() async {
    User? authUser = _auth.currentUser;
    bool res = false;
    if (authUser != null) {
      await _firestore.collection("users").doc(authUser.uid).get().then((ds) {
        if (ds.exists) {
          res = true;
        }
      });
    }
    return res;
  }

  Future<List<MyMasjid>> getNearMasjid(
      double? latitude, double? longitude) async {
    Position position;

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    QuerySnapshot querySnapshot;
    double lat = 0.144927536231884;
    double lon = 0.181818181818182;
    double distance = 1000 * 0.000621371;

    // var tunisLat = 35.1675800;
    // var tunisLon = 8.8365100;
    // double lowerLat = tunisLat - (lat * distance);
    // double lowerLon = tunisLon - (lon * distance);
    // double greaterLat = tunisLat + (lat * distance);
    // double greaterLon = tunisLon + (lon * distance);

    double lowerLat = position.latitude - (lat * distance);
    double lowerLon = position.longitude - (lon * distance);
    double greaterLat = position.latitude + (lat * distance);
    double greaterLon = position.longitude + (lon * distance);

    GeoPoint lesserGeopoint = GeoPoint(lowerLat, lowerLon);
    GeoPoint greaterGeopoint = GeoPoint(greaterLat, greaterLon);
    await _firestore
        .collection('masjids')
        .where("positionMasjid", isGreaterThan: lesserGeopoint)
        .where("positionMasjid", isLessThan: greaterGeopoint)
        .where("type", isEqualTo: "MASJID")
        .limit(100)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var result in querySnapshot.docs) {
        masjids.add(MyMasjid.fromDocument(result));
      }
      return masjids;
    });
    return masjids;
  }

  Future<MyMasjid?> getMasjidwithUserId(userId) async {
    MyMasjid? masjid;

    await _firestore
        .collection("masjids")
        .where("userId", isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((result) {
        masjid = MyMasjid.fromDocument(result);
      });
    });
    return masjid;
  }

  Future<MyMasjid?> getCurrentMasjid() async {
    User? authUser = _auth.currentUser;
    MyMasjid? masjid;
    if (authUser != null) {
      masjid = await getMasjidWithId(authUser.uid);
    }
    return masjid;
  }

  Future<void> addMasjid(MyMasjid masjid) async {
    await _firestore
        .collection("masjids")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set(masjid.toMap());
  }

  // Future<void> addMasjid(MyMasjid masjid) async {
  //   await _firestore
  //       .collection("masjids")
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .set(masjid.toMap());
  // }

  Future<MyMasjid?> updateMasjid(MyMasjid masjid) async {
    await FirebaseFirestore.instance
        .collection("masjids")
        .doc(masjid.id)
        .update(masjid.toMap());
    return null;
  }

  static Future<DateTime?> getIqama(Prayer salat, MyMasjid masjid) async {
    DateTime? iqama;
    await FirebaseFirestore.instance
        .collection("masjids")
        .doc(masjid.id)
        .get()
        .then((ds) {
      if (ds.exists) {
        var map = ds[salat.name];
        if (map["fixed"]) {
          iqama = UtilsMasjid().convertTime(map["time"])!;
        } else {
          var now = DateTime.now();
          // DateTime adhan = DateTime(now.year, now.month,
          //     now.day, now.hour, 8);
          DateTime adhan =
              PrayerTimesManager().prayerTimes.timeForPrayer(salat)!;
          iqama = DateTime(adhan.year, adhan.month, adhan.day, adhan.hour,
              adhan.minute + int.parse(map["time"]));
        }
      }
    });
    return iqama;
  }
}
