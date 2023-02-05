import 'package:prayertime/common/masjid.dart';

class HiveMasjid {
  late String id;
  late String name;
  //bool isMain = false;

  HiveMasjid.construct(
      this.name,
      this.id,
      //this.isMain,
      );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      //'isMain': isMain
    };
  }

  factory HiveMasjid.fromMap(Map map) {
    return HiveMasjid.construct(
        map["name"],
      map["id"],
      //map["isMain"],
);
  }
  factory HiveMasjid.fromMyMasjid(MyMasjid masjid) {
    return HiveMasjid.construct(
      masjid.name,
      masjid.id
    );
  }
}
