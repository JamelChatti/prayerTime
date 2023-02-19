// import 'package:prayertime/common/masjid.dart';
//
// class HiveMasjid {
//   late String id;
//   late String name;
//
//
//   //bool isMain = false;
//
//   HiveMasjid.construct(
//       this.name,
//       this.id,
//
//
//       //this.isMain,
//
//       );
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id' : id,
//       'name': name,
//
//     };
//   }
//
//   factory HiveMasjid.fromMap(Map map) {
//     return HiveMasjid.construct(
//         map["name"],
//       map["id"],
//
//       //map["isMain"],
// );
//   }
//   factory HiveMasjid.fromMyMasjid(MyMasjid masjid) {
//     return HiveMasjid.construct(
//       masjid.name,
//       masjid.id,
//
//     );
//   }
// }

//
// import 'dart:convert';
//
// import 'package:prayertime/common/masjid.dart';
//
// class HiveMasjid {
//   String address = '';
//   late String id;
//   late String name;
//   String country = '';
//   late String state;
//   late String city;
//   late String joumoua;
//   late String aid;
//   late String tahajod;
//   late bool womenMousalla;
//   late bool handicapPass;
//   late bool ablution;
//   late String userId;
//   late bool existJoumoua;
//   late bool existAid;
//    late bool existTahajod ;
//   late bool carPark;
//   late String introduction;
//
//   HiveMasjid.construct(
//       this.address,
//       this.name,
//       this.country,
//       this.city,
//       this.state,
//       this.joumoua,
//       this.aid,
//       this.tahajod,
//       this.ablution,
//       this.handicapPass,
//       this.womenMousalla,
//       this.userId,
//       this.id,
//       this.existJoumoua,
//       this.existAid,
//       this.existTahajod,
//       this.carPark,
//       this.introduction);
//
//   String toJson() {
//     return json.encode(toMap());
//   }
//
//   Map<String, dynamic> toMap() {
//     Map<String, dynamic> map = {
//       'address': address,
//       'name': name,
//       'country': country,
//       'state': state,
//       'city': city,
//       'joumoua': joumoua,
//       'aid': aid,
//       'tahajod': tahajod,
//       'ablution': ablution,
//       'handicapPass': handicapPass,
//       'womenMousalla': womenMousalla,
//       'userId': userId,
//       'id': id,
//       'existJoumoua': existJoumoua,
//       'existAid': existAid,
//       'existTahajod;': existTahajod,
//       'carPark': carPark,
//       'introduction': introduction
//     };
//     return map;
//   }
//
//
//   factory HiveMasjid.fromMyMasjid(MyMasjid masjid) {
//
//     return HiveMasjid.construct(
//         masjid.address,
//         masjid.name,
//         masjid.country,
//         masjid.state,
//         masjid.city,
//         masjid.joumoua,
//         masjid.aid,
//         masjid.tahajod,
//         masjid.ablution,
//         masjid.handicapPass,
//         masjid.womenMousalla,
//         masjid.userId,
//         masjid.id,
//         masjid.existJoumoua,
//         masjid.existAid,
//         masjid.existTahajod,
//         masjid.carPark,
//         masjid.introduction);
//   }
//
//   factory HiveMasjid.fromJson(String userJson) {
//     Map<String, dynamic> map = json.decode(userJson);
//     return HiveMasjid.fromMap(map);
//   }
//
//   factory HiveMasjid.fromMap(Map map) {
//     return HiveMasjid.construct(
//         map["address"],
//         map["name"],
//         map["country"],
//         map["state"],
//         map["city"],
//         map["joumoua"],
//         map["aid"],
//         map["tahajod"],
//         map["ablution"],
//         map["handicapPass"],
//         map["womenMousalla"],
//         map["userId"],
//         map["id"],
//         map["existJoumoua"],
//         map["existAid"],
//         false,
//         map["carPark"],
//         map["introduction"]);
//   }
// }
//
// class Salat {
//   late bool fixed;
//   late String time;
//
//   Salat();
//
//   factory Salat.fromDocumentObject(var documentMap) {
//     var dhuhrMap = Map<String, dynamic>.from(documentMap);
//     bool fixed = dhuhrMap["fixed"];
//     String time = dhuhrMap["time"];
//     return Salat.construct(fixed, time);
//   }
//
//   Map<String, dynamic> toMap() {
//     Map<String, dynamic> map = {
//       'fixed': fixed,
//       'time': time,
//     };
//     return map;
//   }
//
//   Salat.construct(this.fixed, this.time);
//
//   factory Salat.fromJson(String salatJson) {
//     Map<String, dynamic> map = json.decode(salatJson);
//     return Salat.fromMap(map);
//   }
//
//   factory Salat.fromMap(Map map) {
//     return Salat.construct(map["fixed"], map["time"]);
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/masjid.dart';

class HiveMasjid {
  late String id;
  late String name;
  late double latitude;
  late double longitude;

  HiveMasjid.construct({ required this.name, required this.id, required this.latitude, required this.longitude});

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
