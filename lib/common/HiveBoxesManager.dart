import 'package:hive/hive.dart';
import 'package:prayertime/class/hive_masjid.dart';
import 'package:prayertime/class/mymasjid_adapter.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/masjid.dart';

import 'constants.dart';

class HiveBoxesManager {

  Future<void> deleteHiveBoxes() async {
    Hive.deleteBoxFromDisk(HiveBoxConst.myMasjidsBoxName);
    Hive.deleteBoxFromDisk(HiveBoxConst.mainMasjidBoxName);
    Hive.deleteBoxFromDisk(HiveBoxConst.userBoxName);
  }

  Future<void> initHiveBoxes() async {
    Hive.registerAdapter(HiveMasjidAdapter());

    if (!Hive.isBoxOpen(HiveBoxConst.myMasjidsBoxName)) {
      await Hive.openBox<HiveMasjid>(HiveBoxConst.myMasjidsBoxName);
    }
    if (!Hive.isBoxOpen(HiveBoxConst.mainMasjidBoxName)) {
      await Hive.openBox<HiveMasjid>(HiveBoxConst.mainMasjidBoxName);
    }
    if (!Hive.isBoxOpen(HiveBoxConst.userBoxName)) {
      await Hive.openBox<String>(HiveBoxConst.userBoxName);
    }
  }

  Box<String> get userBox{
    return Hive.box<String>(HiveBoxConst.userBoxName);
  }
  Box<HiveMasjid> get mainMasjidBox{
    return Hive.box<HiveMasjid>(HiveBoxConst.mainMasjidBoxName);;
  }
  Box<HiveMasjid> get myMasjidsBox{
    return Hive.box<HiveMasjid>(HiveBoxConst.myMasjidsBoxName);
  }

  void updateMainMasjid(MyMasjid newMainMasjid) {
    HiveMasjid hiveMasjid = HiveMasjid.fromMyMasjid(newMainMasjid);
    mainMasjidBox.put("mainMasjid", hiveMasjid);
    mainMasjid = newMainMasjid;
  }

}