import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prayertime/common/utils.dart';

class PasswordForgotten extends StatefulWidget {
  @override
  _PasswordForgottenState createState() => _PasswordForgottenState();
}

class _PasswordForgottenState extends State<PasswordForgotten> {
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();

  bool shouldPop = true;

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mot de passe oublier'),
        ),
        body: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Inserer votre email et appuyer envoyer un email de réinitialisation du mot '
                            'de passe vous sera envoyer,appuyer sur le lien fourni et saisir le nouveau '
                            'mot de passe.',
                        style: TextStyle(fontSize: 17),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
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
                      ElevatedButton(
                        child: const Text(
                          'Envoyer',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          sendpasswordresetemail(_emailController.text.trimRight());
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => const UpdatePrayerTime()));
                        },
                      ),
                    ],
                  )),
            )),
      ),
    );
  }

  void sendpasswordresetemail(String email) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      UtilsMasjid().toastMessage(
          "Email réinitialisation du mot de passe envoyer", Colors.red);
    }).catchError((onError) {
      onError.toString();

      UtilsMasjid().toastMessage("Error In Email Reset", Colors.red);
    });
  }
}
