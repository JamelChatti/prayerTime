import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/user_service.dart';
import 'package:prayertime/home_page.dart';
import 'package:prayertime/login/new_register.dart';
import 'package:prayertime/login/password_forgotten.dart';
import 'package:prayertime/masjid_update.dart';
import 'package:prayertime/services/auth_service.dart';
import 'package:prayertime/services/masjid_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStoreInstance = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  MasjidService masjidService = MasjidService();
  MyMasjid? masjid;
  bool obscure = true;
  bool shouldPop = true;
  bool showMsg = false;
  String errorMsg = '';

  @override
  void dispose() {
    _emailController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        return !shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Se connecter'),
          // leading: IconButton(
          //   icon: const Icon(Icons.home),
          //   onPressed: Utils.goToWithReplacement(context, const HomePage2()),
          // ),
        ),
        body: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  showMsg ? errorMsgContainer(errorMsg) : Container(),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      icon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Fill Email Input';
                      }
                      if (!EmailValidator.validate(value.trimRight())) {
                        return 'Saisir un email valide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            icon: Icon(Icons.password),
                          ),
                          obscureText: obscure,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Fill Password Input';
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                              child: const Icon(Icons.visibility)))
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await _authService.signInEmail(
                              _emailController.text.trim(),
                              _passwordController.text);
                          if (currentUser != null) {
                            masjid = await masjidService
                                .getMasjidwithUserId(currentUser!.id);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (context) => MasjidUpdate(
                                        user: currentUser!, masjid: masjid!)));
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (context) => HomePage()));
                          }
                        } on FirebaseAuthException catch (e) {
                          print("Exception $e");
                          if (e.code == "user-not-found") {
                            setState(() {
                              showMsg = true;
                              errorMsg = 'user not found';
                            });
                          } else if (e.code == "wrong-password") {
                            setState(() {
                              showMsg = true;
                              errorMsg = "wrong password";
                            });
                          }
                        }
                      }
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    child: const Text(
                      'Mot de passe oublié ',
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PasswordForgotten()));
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: const Text(
                      'Ajouter un nouveau compte ',
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NewRegister()));
                    },
                  )
                ],
              )),
            )),
      ),
    );
  }

  Container errorMsgContainer(String msg) {
    return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.deepOrange,
            ),
            color: Colors.red.shade50,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 28.0),
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 40,
              ),
            ),
            Text(
              msg,
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
          ],
        ));
  }
}
