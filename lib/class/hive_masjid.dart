import 'package:prayertime/common/masjid.dart';

class HiveMasjid {
  late String id;
  late String name;
  late double latitude;
  late double longitude;

  HiveMasjid.construct(
      {required this.name,
      required this.id,
      required this.latitude,
      required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory HiveMasjid.fromMap(Map map) {
    return HiveMasjid.construct(
      name: map["name"],
      id: map["id"],
      latitude: map["latitude"],
      longitude: map["longitude"],
    );
  }

  factory HiveMasjid.fromMyMasjid(MyMasjid masjid) {
    return HiveMasjid.construct(
      name: masjid.name,
      id: masjid.id,
      latitude: masjid.positionMasjid.latitude,
      longitude: masjid.positionMasjid.longitude,
    );
  }
}
