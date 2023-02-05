import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:prayertime/class/map_location.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/common/user_service.dart';
import 'package:prayertime/masjid_update.dart';
import 'package:prayertime/services/auth_service.dart';
import 'package:prayertime/services/masjid_services.dart';
import 'package:prayertime/user.dart';

class NewRegister extends StatefulWidget {
  const NewRegister({Key? key}) : super(key: key);

  @override
  _NewRegisterState createState() => _NewRegisterState();
}

class _NewRegisterState extends State<NewRegister> {
  int _activeStepIndex = 0;
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  LatLng _center = LatLng(35.72917, 10.58082);
  LatLng? position;
MyMasjid? _masjid;
  final iqFormat = DateFormat.Hm();
  String countryValue = '';
  String stateValue = '';
  String cityValue = '';
  List<bool> timeOverVisibility = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //TODO validate
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController masjidController = TextEditingController();
  final TextEditingController masjidNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController responsibleController = TextEditingController();

  TextEditingController asrTimeinput = TextEditingController();
  TextEditingController maghrebTimeinput = TextEditingController();
  TextEditingController ichaTimeinput = TextEditingController();
  TextEditingController joumouaTimeinput = TextEditingController();
  TextEditingController aidTimeinput = TextEditingController();
  final TextEditingController masjidTimeinput = TextEditingController();
  TextEditingController dhohrTimeinput = TextEditingController();
  TextEditingController fajrTimeOverController = TextEditingController();
  TextEditingController dhuhrTimeOverController = TextEditingController();
  TextEditingController asrTimeOverController = TextEditingController();
  TextEditingController maghribTimeOverController = TextEditingController();
  TextEditingController ishaTimeOverController = TextEditingController();

  TextEditingController fajrTimeinput = TextEditingController();
  PrayerTimesManager prayerTimesManager = PrayerTimesManager();
  GoogleMapExampleAppPage googleMapExampleAppPage = GoogleMapExampleAppPage(
      initialPosition:
      CameraPosition(target: LatLng(37.4219999, -122.0840575)));
  List<Placemark>? placemarks;
  var expression = RegExp('([-]?)([0-9]+)');
  Marker marker = const Marker(markerId: MarkerId("1"));
  GoogleMapController? _controller;
  final format = DateFormat("yyyy-MM-dd");
  final format2 = DateFormat("dd-MM-yyyy");
  String _email = '';
  String _password = '';
  String dropdownValue = 'MASJID';

  //TODO gender reinitializes on Back???
  final UserService userService = UserService();
  final MasjidService masjidService = MasjidService();

  final fireStoreInstance = FirebaseFirestore.instance;
  bool userFieldExist = false;

  final AuthService _authService = AuthService();

  void _onMarkerTapped(String markerId) {
    print("Marker Tapped: $markerId");
  }

  void _getPlace(LatLng position) async {
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // this is all you need
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    timeOverVisibility = List.filled(5, false);
  }

  List<Step> stepList() => [
        Step(
          state:
              _activeStepIndex <= 0 ? StepState.disabled : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text(''),
          content: Form(
            key: _formKeys[0],
            child: Column(
              children: [
                const Text(
                  'Identité',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    labelText: 'Nom ',
                    hintText: 'Nom ',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez saisir votre nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _lastnameController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    labelText: 'Prénom ',
                    hintText: 'Prénom ',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez saisir votre prénom';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.home),
                  ),
                  value: dropdownValue,
                  // icon: const Icon(Icons.arrow_downward),
                  // iconSize: 20,
                  elevation: 16,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  onChanged: (newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    'MASJID',
                    'DOMICILE',
                    'LIEU DE TRAVAIL',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        Step(
            state:
                _activeStepIndex <= 1 ? StepState.disabled : StepState.complete,
            isActive: _activeStepIndex >= 1,
            title: const Text(''),
            content: Form(
              key: _formKeys[1],
              child: Column(
                children: [
                  const Text(
                    'Compte',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.email),
                      hintText: 'Votre email',
                      labelText: 'E-mail',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'SVP saisir un email';
                      }
                      if (!EmailValidator.validate(value.trimRight())) {
                        return 'Saisir un email valide';
                      }
                      return null;
                    },
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (String? value) {
                      _email = value!;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  PasswordField(
                    fieldKey: _passwordFieldKey,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuiller remplir ce champ par un mot de passe ';
                      }
                      if (value.length < 8) {
                        return 'Le mot de passe de contenir au moins 8 caractères.';
                      }
                      return null;
                    },
                    helperText: 'Pas moins de 8 characters.',
                    labelText: 'Password *',
                    onChanged: (String value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  const SizedBox(height: 15.0),
                  // "Re-type password" form.
                  TextFormField(
                    controller: confirmPassword,
                    enabled: _password.isNotEmpty,
                    validator: (value) {
                      if (value!.isEmpty || value != _password) {
                        return 'La saisie doit être confirme au mot de passe';
                      }

                      return null;
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(8),
                    ],
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      labelText: 'Re-type password',
                    ),
                    maxLength: 8,
                    obscureText: true,
                  ),
                ],
              ),
            )),
        Step(
            state:
                _activeStepIndex <= 2 ? StepState.disabled : StepState.complete,
            isActive: _activeStepIndex >= 2,
            title: const Text(''),
            content: Form(
              key: _formKeys[2],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Center(
                      child: Text(
                    'IDENTIFICATION DU MASJID',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  )),
                  TextFormField(
                    controller: responsibleController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.person),
                      labelText: 'Nom du responsable ',
                      hintText: 'Nom du responsable',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez saisir le nom du responsable';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: masjidNameController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.home),
                      labelText: 'Nom du masjid ',
                      hintText: 'Nom du masjid',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez saisir le nom du masjid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: addressController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(Icons.location_city),
                      labelText: 'Adresse ',
                      hintText: 'Adresse ',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez saisir l\'adresse du masjid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SelectState(
                          // style: TextStyle(color: Colors.red),
                          onCountryChanged: (value) {
                            setState(() {
                              countryValue = value;
                            });
                          },
                          onStateChanged: (value) {
                            setState(() {
                              stateValue = value;
                            });
                          },
                          onCityChanged: (value) {
                            setState(() {
                              cityValue = value;
                            });
                          },
                        ),
                        // InkWell(
                        //   onTap:(){
                        //     print('country selected is $countryValue');
                        //     print('country selected is $stateValue');
                        //     print('country selected is $cityValue');
                        //   },
                        //   child: Text(' Check')
                        // )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )),
        Step(
            state:
                _activeStepIndex <= 3 ? StepState.disabled : StepState.complete,
            isActive: _activeStepIndex >= 3,
            title: const Text(''),
            content: Form(
              key: _formKeys[3],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Center(
                      child: Text(
                    'LOCALISATION DU MASJID',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                      height: 400,
                      width: 350,
                      child: GoogleMap(
                        myLocationButtonEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 11.0,
                        ),
                        markers: {marker},
                        polygons: googleMapExampleAppPage.polygons,
                        polylines: googleMapExampleAppPage.polylines,
                        circles: googleMapExampleAppPage.circles,
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                        },
                        onTap: (value) {
                          print(value);
                          setState(() {
                            marker = Marker(
                                draggable: true,
                                markerId: const MarkerId("1"),
                                position: value,
                                icon: BitmapDescriptor.defaultMarker,
                                onTap: () {
                                  _onMarkerTapped("1");
                                });
                            _center = value;
                          });
                          print(_center);
                          _getPlace(_center);
                          // print(placemarks![0].locality);
                          // print(placemarks![0].country);
                        },
                      )
                      // GoogleMap(
                      //   initialCameraPosition: CameraPosition(
                      //     target: _center,
                      //     zoom: 11.0,
                      //   ),
                      //   onTap: (value) {
                      //     print(value);
                      //     setState(() {
                      //       _center = value;
                      //     });
                      //     print(_center);
                      //     _getPlace(_center);
                      //     // print( placemarks![0].locality );
                      //     // print( placemarks![0].country);
                      //   },
                      // )
                  ),
                  placemarks != null
                      ? SizedBox(
                          height: 40,
                          child: Text(placemarks![0].locality.toString() +
                              placemarks![0].country.toString()),
                        )
                      : Container()
                ],
              ),
            )),
        Step(
            state: StepState.complete,
            isActive: _activeStepIndex >= 4,
            title: const Text(''),
            content: Form(
              key: _formKeys[4],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Center(
                      child: Text(
                    'Confirmation',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  )),
                  Text('Nom:    ${_nameController.text}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Prénom: ${_lastnameController.text}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Email: ${_emailController.text}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text('Mot de passe : *****',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Responsable ${responsibleController.text}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Nom du masjid ${masjidNameController.text}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Adresse du masjid ${addressController.text}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Pays ${countryValue}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Gouvernorat: ${stateValue}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Delegation: ${cityValue}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  placemarks != null
                      ? Column(
                          children: [
                            Text('Pays: ${placemarks![0].country}',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('Ville: ${placemarks![0].locality}',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ))
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enregistrer un utilisateur'),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _activeStepIndex,
        steps: stepList(),
        onStepContinue: () {
          if (_activeStepIndex < (stepList().length - 1)) {
            setState(() {
              _activeStepIndex += 1;
            });
          }
        },
        onStepCancel: () {
          if (_activeStepIndex == 0) {
            return;
          }

          setState(() {
            _activeStepIndex -= 1;
          });
        },
        onStepTapped: (int index) {
          setState(() {
            _activeStepIndex = index;
          });
        },
        controlsBuilder: (context, details) {
          final isLastStep = _activeStepIndex == stepList().length - 1;
          return Row(
            children: [
              if (_activeStepIndex > 0)
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Retour'),
                  ),
                ),
              if (_activeStepIndex > 0)
                const SizedBox(
                  width: 10,
                ),
              Expanded(
                child: ElevatedButton(
                  onPressed: isLastStep
                      ? () async {
                          if (_formKeys[_activeStepIndex]
                              .currentState!
                              .validate()) {
                            if (cityValue == 'Choose City') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.rightSlide,
                                title: 'Dialog Title',
                                desc: 'Choisir une ville',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              ).show();
                            } else {

                              bool success = await addUserAndMasjid( );

                              if (success ) {
                                if (!mounted) {
                                  Utils.goToWithReplacement(
                                    context,  MasjidUpdate(user: currentUser!,masjid: _masjid!,));
                                }
                              } else {

                                //TODO chnoua ysir ki mayet3addech
                              }
                            }
                          }
                        }
                      : () {
                          if (_formKeys[_activeStepIndex]
                              .currentState!
                              .validate()) details.onStepContinue!();
                        },
                  child: (isLastStep)
                      ? const Text('Valider')
                      : const Text('Continuer'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
 
  Future<MyMasjid> getMosque() async{
    MyMasjid masjid;
   await _firestore.collection('masjids')
    .where("userId",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
    .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((result) {
        masjid = MyMasjid.fromDocument(result);
      });

    });
   return getMosque();

  }
  
  Future<void> addMasjid() async {
    bool success = false;
    FirebaseFirestore.instance.collection('masjids').add({
      "responsibleName": responsibleController.text,
      "address": addressController.text,
      "name": masjidNameController.text,
      "country": countryValue,
      "city": cityValue,
      "state": stateValue,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "userId": FirebaseAuth.instance.currentUser?.uid,
      "positionMasjid":  GeoPoint(_center.latitude,_center.longitude),
    });

  }

  Future<void> addUser() async {
    bool success = false;
   // try {
      var result = await _authService.signUp(
          _emailController.text, confirmPassword.text);
      MyUser user = MyUser.construct(
        _emailController.text,
        _lastnameController.text,
        _nameController.text,
        //TODO Validator for cin
        dropdownValue,
        '',
      );
      await userService.addUser(user);
  }

  Future<bool> addUserAndMasjid() async{
    bool success = false;
    try {
      await addUser();
      await addMasjid();
      masjidService.getMasjidwithUserId(FirebaseAuth.instance.currentUser?.uid).then((value) => _masjid=value);
      Utils()
          .toastMessage("Enregistrement terminé avec succès", Colors.blue);
      if (!mounted) {
        Utils.goToWithReplacement(
            context,  MasjidUpdate(user: currentUser!,masjid: _masjid!,));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Utils().toastMessage(
            'The password provided is too weak.', Colors.deepOrange);
      } else if (e.code == 'email-already-in-use') {
        Utils().toastMessage(
            'The account already exists for that email.', Colors.deepOrange);
      }
    } catch (e) {
      print(e);
    }
    success = true;

return success;

  }

}

class PasswordField extends StatefulWidget {
  const PasswordField(
      {this.fieldKey,
      this.hintText,
      this.labelText,
      this.helperText,
      this.onSaved,
      this.validator,
      this.onFieldSubmitted,
      this.onChanged,
      Key? key})
      : super(key: key);

  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
//AIzaSyBVB2HLxdyG4Zt-067212h_LRcApdOUAsQ
