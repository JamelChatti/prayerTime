import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  late String email;
  late String lastname;
  late String? id;
  late String name;
 late String type;

  MyUser();

  MyUser.construct(
      this.email,
      this.lastname,
      this.name,
      this.type,
      this.id);


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
  factory MyUser.fromDocument(DocumentSnapshot documentSnapshot) {
    return MyUser.construct(
      documentSnapshot["email"],
      documentSnapshot["lastname"],
      documentSnapshot["name"],
      documentSnapshot["type"],
        documentSnapshot.id,
    );
  }

  factory MyUser.fromJson(String userJson) {
    Map<String, dynamic> map = json.decode(userJson);
    return MyUser.construct(
      map["email"],
      map["lastname"],
      map["name"],
      map["type"],
      map[''],

    );
  }
}
