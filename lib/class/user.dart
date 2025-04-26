import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prayertime/common/masjid.dart';

class MyUser {
  late String email;
  late String lastname;
  late String? id;
  late String name;
 late String type;
  late MyMasjid? masjid;
  MyUser();

  MyUser.construct(
      this.email,
      this.lastname,
      this.name,
      this.type,
      this.id,
      this.masjid);


  String toJson() {
    return json.encode(toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'email': email,
      'lastname': lastname,
      'name': name,
      'type': type,
    };
    return map;}
  factory MyUser.fromDocument(DocumentSnapshot userDocumentSnapshot, DocumentSnapshot? masjidDocumentSnapshot) {
    return MyUser.construct(
      userDocumentSnapshot["email"],
      userDocumentSnapshot["lastname"],
      userDocumentSnapshot["name"],
      userDocumentSnapshot["type"],
      userDocumentSnapshot.id,
      masjidDocumentSnapshot == null? null:MyMasjid.fromDocument(masjidDocumentSnapshot),
    );
  }

}
