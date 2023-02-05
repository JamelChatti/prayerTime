import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/masjid.dart';

class MyMasjid {
  String responsibleName = '';
  String address = '';
  late String id;
  late String name;
  String country = '';
  late String state;
  late String city;
  late int timestamp;
  late Salat fajr;
  late Salat dhuhr;
  late Salat asr;
  late Salat maghrib;
  late Salat isha;
  late String joumoua;
  late String aid;
  late String tahajod;
  late bool womenMousalla;
  late bool handicapPass;
  late bool ablution;
  late String userId;
  late bool existJoumoua;
  late bool existAid;
  late bool existtAhajod;
  late bool carPark;
  late GeoPoint positionMasjid;


  MyMasjid.construct(
      this.responsibleName,
      this.address,
      this.name,
      this.country,
      this.city,
      this.state,
      this.timestamp,
      this.fajr,
      this.dhuhr,
      this.asr,
      this.maghrib,
      this.isha,
      this.joumoua,
      this.aid,
      this.tahajod,
      this.ablution,
      this.handicapPass,
      this.womenMousalla,
      this.userId,
      this.id,
      this.existJoumoua,
      this.existAid,
      this.existtAhajod,
      this.carPark,
      this.positionMasjid);

  String toJson() {
    return json.encode(toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'responsibleName': responsibleName,
      'address': address,
      'name': name,
      'country': country,
      'state': state,
      'city': city,
      'timestamp': timestamp,
      'fajr': fajr.toMap(),
      'dhuhr': dhuhr.toMap(),
      'asr': asr.toMap(),
      'maghrib': maghrib.toMap(),
      'isha': isha.toMap(),
      'joumoua': joumoua,
      'aid': aid,
      'tahajod': tahajod,
      'ablution': ablution,
      'handicapPass': handicapPass,
      'existJoumoua': existJoumoua,
      'womenMousalla': womenMousalla,
      'existAid': existAid,
      'userId': userId,
      'existtAhajod': existtAhajod,
      'carPark': carPark,
      'positionMasjid': positionMasjid,
    };
    return map;
  }

  Map<String, dynamic> toMapForHiveAdapter() {
    Map<String, dynamic> map = toMap();
    map['positionMasjid'] = {
      'latitude': positionMasjid.latitude,
      "longitude": positionMasjid.longitude
    };
    map.putIfAbsent('id', () => id);
    return map;
  }

  factory MyMasjid.fromDocument(DocumentSnapshot documentSnapshot) {
    String responsibleName = documentSnapshot["responsibleName"];
    String address = documentSnapshot["address"];
    String city = documentSnapshot["city"];
    String id = documentSnapshot.id;
    String name = documentSnapshot["name"];
    String country = documentSnapshot["country"];
    String state = documentSnapshot["state"];
    Salat dhuhr = Salat();
    try {
      dhuhr = Salat.fromDocumentObject(documentSnapshot["dhuhr"]);
    } catch (e) {}
    Salat asr = Salat();
    try {
      asr = Salat.fromDocumentObject(documentSnapshot["asr"]);
    } catch (e) {}
    Salat maghrib = Salat();
    try {
      maghrib = Salat.fromDocumentObject(documentSnapshot["maghrib"]);
    } catch (e) {}
    Salat isha = Salat();
    try {
      isha = Salat.fromDocumentObject(documentSnapshot["isha"]);
    } catch (e) {}
    String joumoua = '';
    try {
      joumoua = documentSnapshot["joumoua"];
    } catch (e) {}
    String aid = '';
    try {
      aid = documentSnapshot["aid"];
    } catch (e) {}
    String tahajod = '';
    try {
      tahajod = documentSnapshot["tahajod"];
    } catch (e) {}
    Salat fajr = Salat();
    try {
      fajr = Salat.fromDocumentObject(documentSnapshot["fajr"]);
    } catch (e) {}
    bool womenMousalla = false;
    try {
      womenMousalla = documentSnapshot['womenMousalla'];
    } catch (e) {}
    bool handicapPass = false;
    try {
      handicapPass = documentSnapshot['handicapPass'];
    } catch (e) {}
    bool ablution = false;
    try {
      ablution = documentSnapshot['ablution'];
    } catch (e) {}
    String userId = documentSnapshot["userId"];
    documentSnapshot.id;
    bool existJoumoua = false;
    try {
      existJoumoua = documentSnapshot["existJoumoua"];
    } catch (e) {}
    bool existAid = false;
    try {
      existAid = documentSnapshot["existAid"];
    } catch (e) {}
    bool existtAhajod = false;
    try {
      existtAhajod = documentSnapshot["existtAhajod"];
    } catch (e) {}
    bool carPark = false;
    try {
      carPark = documentSnapshot["carPark"];
    } catch (e) {}

    final GeoPoint positionMasjid = documentSnapshot['positionMasjid'];

    return MyMasjid.construct(
        responsibleName,
        address,
        name,
        country,
        state,
        city,
        DateTime.now().millisecondsSinceEpoch,
        fajr,
        dhuhr,
        asr,
        maghrib,
        isha,
        joumoua,
        aid,
        tahajod,
        ablution,
        handicapPass,
        womenMousalla,
        userId,
        id,
        existJoumoua,
        existAid,
        existtAhajod,
        carPark,
        positionMasjid);
  }

  factory MyMasjid.fromJson(String userJson) {
    Map<String, dynamic> map = json.decode(userJson);
    return MyMasjid.fromMap(map);
  }

  factory MyMasjid.fromMap(Map map) {
    return MyMasjid.construct(
        map["responsibleName"],
        map["address"],
        map["name"],
        map["country"],
        map["state"],
        map["city"],
        map["timestamp"],
        Salat.fromMap(map["fajr"]),
        Salat.fromMap(map["dhuhr"]),
        Salat.fromMap(map["asr"]),
        Salat.fromMap(map["maghrib"]),
        Salat.fromMap(map["isha"]),
        map["joumoua"],
        map["aid"],
        map["tahajod"],
        map["ablution"],
        map["handicapPass"],
        map["womenMousalla"],
        map["userId"],
        map["id"],
        map["existJoumoua"],
        map["existAid"],
        map["existtAhajod"],
        map["carPark"],
        GeoPoint(map['positionMasjid']['latitude'],
            map['positionMasjid']['longitude']));
  }
}

class Salat {
  late bool fixed;
  late String time;

  Salat();

  factory Salat.fromDocumentObject(var documentMap) {
    var dhuhrMap = Map<String, dynamic>.from(documentMap);
    bool fixed = dhuhrMap["fixed"];
    String time = dhuhrMap["time"];
    return Salat.construct(fixed, time);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'fixed': fixed,
      'time': time,
    };
    return map;
  }

  Salat.construct(this.fixed, this.time);

  factory Salat.fromJson(String salatJson) {
    Map<String, dynamic> map = json.decode(salatJson);
    return Salat.fromMap(map);
  }

  factory Salat.fromMap(Map map) {
    return Salat.construct(map["fixed"], map["time"]);
  }
}
