import 'package:firebase_auth/firebase_auth.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/common/constants.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/login_status_enum.dart';
import 'package:prayertime/common/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService userService = UserService();

  void initListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        if (currentUser != null) {
          await _completeLogout();
        }
      } else {
        if (currentUser == null) {
          await _completeLogin(user);
        }
      }
    });
  }

  Future<void> _completeLogin(User user) async {
    Utils.localStorage!.setString(StorageConst.email, user.email!);
    //bool regisComplete = await UserService.registrationComplete();
    //Utils.localStorage!.setBool(StorageConst.regisComplete, regisComplete);

    //TODO check if local storage necessary

    await userService.initCurrentUser();
  }

  Future<void> _completeLogout() async {
    Utils.localStorage!.clear();
    userService.uninitializeCurrentUser();
  }

  Future<LoginStatus> checkIfLoggedIn() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await userService.initCurrentUser();
      if (currentUser == null) {
        await _completeLogin(user);
      }
      return LoginStatus.loggedIn;
    }
    return LoginStatus.loggedOff;
  }

  Future<User> signInEmail(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user!;
    await _completeLogin(user);
    return user;
  }

  Future<User> signUp(email, password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user!;
    await _completeLogin(user);
    return user;
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
    await _completeLogout();
  }
}
