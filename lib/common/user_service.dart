import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prayertime/common/constants.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/class/user.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/services/masjid_services.dart';

class UserService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static Future<MyUser?> getUserWithId(String id) async {
    MyUser? user;

    await _firestore.collection(Collections.users).doc(id).get().then((ds) {
      if (ds.exists) {
        //String usertype
        user = MyUser.fromDocument(ds, null);
      }
    });
    if (user != null) {
      var masjidService = MasjidService();
      MyMasjid? masjid = await masjidService.getMasjidwithUserId(id);
      user!.masjid = masjid;
    }
    return user;
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

  Future<void> initCurrentUser() async {
    currentUser = await getCurrentUser();
  }

  void uninitializeCurrentUser() {
    currentUser = null;
  }

  Future<MyUser?> getCurrentUser() async {
    User? authUser = _auth.currentUser;
    MyUser? user;
    if (authUser != null) {
      user = await getUserWithId(authUser.uid);
    }
    return user;
  }

  Future<void> addUser(MyUser user) async {
    await _firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set(user.toMap());
  }

  Future<String> addPharmacy(String registrNum) async {
    String pharmacyId = "";
    await _firestore.collection("users").add({
      'name': currentUser!.lastname + currentUser!.name,
      'email': currentUser!.email,
    }).then((value) => pharmacyId = value.id);
    return pharmacyId;
  }

  Future<MyUser?> updateUser(MyUser user) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.id)
        .update(user.toMap());
    initCurrentUser();
    return currentUser;
  }
}
