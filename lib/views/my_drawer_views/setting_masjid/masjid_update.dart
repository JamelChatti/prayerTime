import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:prayertime/views/my_drawer_views/adhan.dart';
import 'package:prayertime/class/map_location.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/home_page.dart';
import 'package:prayertime/class/user.dart';
import 'package:progress_state_button/progress_button.dart';

class MasjidUpdate extends StatefulWidget {
  final MyUser user;
  final MyMasjid masjid;

  const MasjidUpdate({
    required this.user,
    required this.masjid,
    Key? key,
  }) : super(key: key);

  @override
  _MasjidUpdateState createState() => _MasjidUpdateState();
}

class _MasjidUpdateState extends State<MasjidUpdate> {
  int _activeStepIndex = 0;
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  bool isCheckedJoumoua = false;
  bool isCheckedTahajod = false;
  bool isCheckedAid = false;
  bool isCheckedCarPark = false;
  bool isCheckedWomanMousalla = false;
  bool isCheckedHandicapPass = false;
  bool isCheckedAblution = false;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static final f = DateFormat('kk:mm          dd-MM-yyyy');
  GoogleMapController? _controller;

  LatLng _center = LatLng(0, 0);
  LatLng? initTarget;

  LatLng? position;

  final iqFormat = DateFormat.Hm();
  String countryValue = '';
  String stateValue = '';
  String cityValue = '';
  List<bool> afterTimeVisibility = [false, false, false, false, false];
  final Map<String, Image> _loadedImages = Map();
  final Map<String, Image> _loadedDoc = Map();
  final List<String> _toDeleteDocs = [];

  final List<String> _toDeleteImages = [];

  bool saved = false;
  GoogleMapExampleAppPage googleMapExampleAppPage = GoogleMapExampleAppPage(
      initialPosition:
          const CameraPosition(target: LatLng(37.4219999, -122.0840575)));

  //TODO validate
  ButtonState stateOnlyText = ButtonState.idle;
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController masjidController = TextEditingController();
  final TextEditingController masjidNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController responsibleController = TextEditingController();
  TextEditingController tahajodTimeController = TextEditingController();

  TextEditingController asrTimeController = TextEditingController();
  TextEditingController maghribTimeController = TextEditingController();
  TextEditingController ishaTimeController = TextEditingController();
  TextEditingController joumouaTimeController = TextEditingController();
  TextEditingController aidTimeController = TextEditingController();
  final TextEditingController masjidTimeinput = TextEditingController();
  TextEditingController dhuhrTimeController = TextEditingController();
  TextEditingController afterFajrTimeController = TextEditingController();
  TextEditingController afterDhuhrTimeController = TextEditingController();
  TextEditingController afterAsrTimeController = TextEditingController();
  TextEditingController afterMaghribTimeController = TextEditingController();
  TextEditingController afterIshaTimeController = TextEditingController();
  Marker marker = const Marker(markerId: MarkerId("1"));
  TextEditingController fajrTimeController = TextEditingController();
  PrayerTimesManager prayerTimesManager = PrayerTimesManager();
  List<Placemark>? placemarks;
  var expression = RegExp('([-]?)([0-9]+)');
  final ImagePicker imagePicker = ImagePicker();
  double _progress = 0;
  double _progressDoc = 0;

  final format = DateFormat("yyyy-MM-dd");
  final format2 = DateFormat("dd-MM-yyyy");
  String dropdownValue = 'MASJID';
  int imageUploaded = 0;
  int docUploaded = 0;

  final fireStoreInstance = FirebaseFirestore.instance;
  bool userFieldExist = false;
  final List<XFile> _selectedImages = [];
  final List<XFile> _selectedDoc = [];


  void _getPlace(LatLng position) async {
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // this is all you need
  }

  void getDescription() async {
    responsibleController.text = widget.masjid.responsibleName;
    masjidNameController.text = widget.masjid.name;
    addressController.text = widget.masjid.address;
    cityValue = widget.masjid.city;
    countryValue = widget.masjid.country;
    stateValue = widget.masjid.state;
    initTarget =
        LatLng(widget.masjid.positionMasjid.latitude, widget.masjid.positionMasjid.longitude);
    loadImages();
    loadDocs();
    fajrTimeController.text = widget.masjid.fajr.time;
    dhuhrTimeController.text = widget.masjid.dhuhr.time;
    asrTimeController.text = widget.masjid.asr.time;
    maghribTimeController.text = widget.masjid.maghrib.time;
    ishaTimeController.text = widget.masjid.isha.time;
    isCheckedWomanMousalla = widget.masjid.womenMousalla;
    isCheckedJoumoua = widget.masjid.existJoumoua;
    isCheckedTahajod = widget.masjid.existTahajod;
    isCheckedAid = widget.masjid.existAid;
    isCheckedAblution = widget.masjid.ablution;
    isCheckedCarPark = widget.masjid.carPark;
    isCheckedHandicapPass = widget.masjid.handicapPass;
    afterTimeVisibility[0] = !widget.masjid.fajr.fixed;
    afterTimeVisibility[1] = !widget.masjid.dhuhr.fixed;
    afterTimeVisibility[2] = !widget.masjid.asr.fixed;
    afterTimeVisibility[3] = !widget.masjid.maghrib.fixed;
    afterTimeVisibility[4] = !widget.masjid.isha.fixed;
    afterFajrTimeController.text = widget.masjid.isha.time;
    afterDhuhrTimeController.text = widget.masjid.dhuhr.time;
    afterAsrTimeController.text = widget.masjid.asr.time;
    afterMaghribTimeController.text = widget.masjid.maghrib.time;
    afterIshaTimeController.text = widget.masjid.isha.time;
    joumouaTimeController.text = widget.masjid.joumoua;
    aidTimeController.text = widget.masjid.aid;
    tahajodTimeController.text = widget.masjid.tahajod;
  }

  void _onMarkerTapped(String markerId) {
    print("Marker Tapped: $markerId");
  }

  void initState() {
    super.initState();
    // afterTimeVisibility = List.filled(5, false);
    _center =
        LatLng(widget.masjid.positionMasjid.latitude, widget.masjid.positionMasjid.longitude);
    getDescription();
    print(widget.user.name);
    print(widget.masjid.city);
    //markers.addAll(googleMapExampleAppPage.markers);
    marker = Marker(
        draggable: true,
        markerId: const MarkerId("1"),
        position: _center,
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {
          _onMarkerTapped("1");
        });
  }

  List<Step> stepList() => [
        Step(
          state:
              _activeStepIndex <= 0 ? StepState.disabled : StepState.complete,
          isActive: _activeStepIndex >= 0,
          title: const Text(''),
          content: Form(
            key: _formKeys[0],
            child: SizedBox(
              height: 450,
              child: widget.masjid.type== 'MASJID'?
              ListView(
                children: [
                  const Text(
                    'Identité',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  ),
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
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                Text('Joumoua'),
                                Checkbox(
                                  value: isCheckedJoumoua,
                                  onChanged: (value) {
                                    setState(() {
                                      isCheckedJoumoua = value!;
                                    });
                                  },
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                const Text('Aid'),
                                Checkbox(
                                  value: isCheckedAid,
                                  onChanged: (value) {
                                    setState(() {
                                      isCheckedAid = value!;
                                    });
                                  },
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                Text('Tahajod'),
                                Checkbox(
                                  value: isCheckedTahajod,
                                  onChanged: (value) {
                                    setState(() {
                                      isCheckedTahajod = value!;
                                    });
                                  },
                                ),
                              ],
                            )),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                const Text('Mousalla pour femme'),
                                Checkbox(
                                  value: isCheckedWomanMousalla,
                                  onChanged: (value) {
                                    setState(() {
                                      isCheckedWomanMousalla = value!;
                                    });
                                  },
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                Text('salle d\ablution'),
                                Checkbox(
                                  value: isCheckedAblution,
                                  onChanged: (value) {
                                    setState(() {
                                      isCheckedAblution = value!;
                                    });
                                  },
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                Text('Parking                    .'),
                                Checkbox(
                                  value: isCheckedCarPark,
                                  onChanged: (value) {
                                    setState(() {
                                      isCheckedCarPark = value!;
                                    });
                                  },
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                Text('Passage handicapé'),
                                Checkbox(
                                  value: isCheckedHandicapPass,
                                  onChanged: (value) {
                                    setState(() {
                                      isCheckedHandicapPass = value!;
                                    });
                                  },
                                ),
                              ],
                            )),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )
              :ListView(
                children: [
                  const Text(
                    'Identité',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  ),
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

                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
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
              child: widget.masjid.type== 'MASJID'?
              Column(
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
                          target: initTarget!,
                          zoom: 20.0,
                        ),
                        //markers: googleMapExampleAppPage.markers,
                        polygons: googleMapExampleAppPage.polygons,
                        polylines: googleMapExampleAppPage.polylines,
                        circles: googleMapExampleAppPage.circles,
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                        },
                        markers: {marker},

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
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  placemarks != null
                      ? Text(
                          '${placemarks![0].locality}  ${placemarks![0].country}')
                      : Container()
                ],
              )
              :Column(
                children: [
                  const Center(
                      child: Text(
                        'LOCALISATION DU LIEU',
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
                          target: initTarget!,
                          zoom: 20.0,
                        ),
                        //markers: googleMapExampleAppPage.markers,
                        polygons: googleMapExampleAppPage.polygons,
                        polylines: googleMapExampleAppPage.polylines,
                        circles: googleMapExampleAppPage.circles,
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                        },
                        markers: {marker},

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
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  placemarks != null
                      ? Text(
                      '${placemarks![0].locality}  ${placemarks![0].country}')
                      : Container()
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
              child: widget.masjid.type== 'MASJID'?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Center(
                      child: Text(
                    'SAISIR HEURE IQAMA',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold),
                  )),
                  Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: SizedBox(
                        height: 450,
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ListView(children: [
                              Text(f.format(DateTime.now()),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Row(
                                children: [
                                  const Text(' مسجد',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  Text(': ${masjidNameController.text}'),
                                ],
                              ),
                              Row(children: [
                                const Expanded(flex: 2, child: Text(' الفجر')),
                                //  const Expanded(child: Text('الساعة ')),
                                Expanded(
                                  flex: 3,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                    ),
                                    child: afterTimeVisibility[0]
                                        ? const Text(
                                            ' بعدالاذان بـ',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18),
                                          )
                                        : const Text(
                                            ' الساعة ',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18),
                                          ),
                                    onPressed: () async {
                                      setState(() {
                                        afterTimeVisibility[0] =
                                            !afterTimeVisibility[0];
                                      });
                                    },
                                  ),
                                ),
                                !afterTimeVisibility[0]
                                    ? Expanded(
                                        flex: 4,
                                        child: Container(
                                            padding: const EdgeInsets.all(15),
                                            height: 50,
                                            child: Center(
                                                child: TextField(
                                              controller: fajrTimeController,
                                              //editing controller of this TextField
                                              decoration: InputDecoration(
                                                hintText:
                                                    prayerTimesManager.fajr,
                                                // icon: Icon(Icons.timer), //icon of text field
                                                //labelText: "Enter Time" ,
                                              ),
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // print(pickedTime.format(context));   //output 10:51 PM
                                                  DateTime parsedTime =
                                                      DateFormat.Hm().parse(
                                                          pickedTime
                                                              .format(context)
                                                              .toString());
                                                  //converting to DateTime so that we can further format on different pattern.
                                                  print(
                                                      parsedTime); //output 1970-01-01 22:53:00.000
                                                  String formattedTime =
                                                      DateFormat('HH:mm')
                                                          .format(parsedTime);
                                                  print(
                                                      formattedTime); //output 14:59:00
                                                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                                                  setState(() {
                                                    fajrTimeController.text =
                                                        formattedTime; //set the value of text field.
                                                  });
                                                } else {
                                                  print("Time is not selected");
                                                }
                                              },
                                            ))),
                                      )
                                    : Expanded(
                                        flex: 3,
                                        child: Visibility(
                                          visible: afterTimeVisibility[0],

                                          child: TextFormField(
                                            enableInteractiveSelection: false,
                                            autofocus: true,
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.fromLTRB(
                                                  2.0, 10.0, 20.0, 8.0),
                                              hintText: ' ',
                                              filled: true,
                                              fillColor:
                                                  Color.fromARGB(30, 6, 3, -10),
                                              focusColor: Colors.grey,
                                              border: InputBorder.none,
                                            ),
                                            textAlign: TextAlign.center,
                                            controller: afterFajrTimeController,
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value!.isEmpty &&
                                                  afterTimeVisibility[0]) {
                                                return 'Veuillez saisir une valeur';
                                              }
                                              return null;
                                            },
                                            inputFormatters: <TextInputFormatter>[
                                              //WhitelistingTextInputFormatter.digitsOnly
                                              FilteringTextInputFormatter.allow(
                                                  expression)
                                            ],
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                              signed: true,
                                            ),
                                            // Only numbers can be entered
                                          ),
                                        ),
                                      ),
                              ]),
                              Row(children: [
                                const Expanded(flex: 2, child: Text(' الظهر')),
                                //  const Expanded(child: Text('الساعة ')),
                                Expanded(
                                  flex: 3,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                    ),
                                    child: afterTimeVisibility[1]
                                        ? const Text(
                                            ' بعدالاذان بـ',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18),
                                          )
                                        : const Text(
                                            ' الساعة ',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18),
                                          ),
                                    onPressed: () async {
                                      setState(() {
                                        afterTimeVisibility[1] =
                                            !afterTimeVisibility[1];
                                      });
                                    },
                                  ),
                                ),
                                !afterTimeVisibility[1]
                                    ? Expanded(
                                        flex: 4,
                                        child: Container(
                                            padding: const EdgeInsets.all(15),
                                            height: 50,
                                            child: Center(
                                                child: TextField(
                                              controller: dhuhrTimeController,
                                              //editing controller of this TextField
                                              decoration: InputDecoration(
                                                hintText:
                                                    prayerTimesManager.dhuhr,
                                              ),
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // print(pickedTime.format(context));   //output 10:51 PM
                                                  DateTime parsedTime =
                                                      DateFormat.Hm().parse(
                                                          pickedTime
                                                              .format(context)
                                                              .toString());
                                                  //converting to DateTime so that we can further format on different pattern.
                                                  print(
                                                      parsedTime); //output 1970-01-01 22:53:00.000
                                                  String formattedTime =
                                                      DateFormat('HH:mm')
                                                          .format(parsedTime);
                                                  print(
                                                      formattedTime); //output 14:59:00
                                                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                                                  setState(() {
                                                    dhuhrTimeController.text =
                                                        formattedTime; //set the value of text field.
                                                  });
                                                } else {
                                                  print("Time is not selected");
                                                }
                                              },
                                            ))),
                                      )
                                    : Expanded(
                                        flex: 3,
                                        child: Visibility(
                                          visible: afterTimeVisibility[1],
                                          child: TextFormField(
                                            enableInteractiveSelection: false,
                                            autofocus: true,
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      2.0, 10.0, 20.0, 8.0),
                                              hintText: ' ',
                                              filled: true,
                                              fillColor:
                                                  Color.fromARGB(30, 6, 3, -10),
                                              focusColor: Colors.grey,
                                              border: InputBorder.none,
                                            ),
                                            textAlign: TextAlign.center,
                                            controller:
                                                afterDhuhrTimeController,
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value!.isEmpty &&
                                                  afterTimeVisibility[1]) {
                                                return 'Veuillez saisir une valeur';
                                              }
                                              return null;
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              //WhitelistingTextInputFormatter.digitsOnly
                                              FilteringTextInputFormatter.allow(
                                                  expression)
                                            ],
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                              signed: true,
                                            ),
                                            // Only numbers can be entered
                                          ),
                                        ))
                              ]),
                              Row(children: [
                                const Expanded(flex: 2, child: Text(' العصر')),
                                //  const Expanded(child: Text('الساعة ')),
                                Expanded(
                                  flex: 3,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                    ),
                                    child: afterTimeVisibility[2]
                                        ? const Text(
                                            ' بعدالاذان بـ',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18),
                                          )
                                        : const Text(
                                            ' الساعة ',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18),
                                          ),
                                    onPressed: () async {
                                      setState(() {
                                        afterTimeVisibility[2] =
                                            !afterTimeVisibility[2];
                                      });
                                    },
                                  ),
                                ),
                                !afterTimeVisibility[2]
                                    ? Expanded(
                                        flex: 4,
                                        child: Container(
                                            padding: const EdgeInsets.all(15),
                                            height: 50,
                                            child: Center(
                                                child: TextField(
                                              controller: asrTimeController,
                                              //editing controller of this TextField
                                              decoration: InputDecoration(
                                                hintText:
                                                    prayerTimesManager.asr,
                                              ),
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // print(pickedTime.format(context));   //output 10:51 PM
                                                  DateTime parsedTime =
                                                      DateFormat.Hm().parse(
                                                          pickedTime
                                                              .format(context)
                                                              .toString());
                                                  //converting to DateTime so that we can further format on different pattern.
                                                  print(
                                                      parsedTime); //output 1970-01-01 22:53:00.000
                                                  String formattedTime =
                                                      DateFormat('HH:mm')
                                                          .format(parsedTime);
                                                  print(
                                                      formattedTime); //output 14:59:00
                                                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                                                  setState(() {
                                                    asrTimeController.text =
                                                        formattedTime; //set the value of text field.
                                                  });
                                                } else {
                                                  print("Time is not selected");
                                                }
                                              },
                                            ))),
                                      )
                                    : Expanded(
                                        flex: 3,
                                        child: Visibility(
                                          visible: afterTimeVisibility[2],
                                          child: TextFormField(
                                            enableInteractiveSelection: false,
                                            autofocus: true,
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      2.0, 10.0, 20.0, 8.0),
                                              hintText: ' ',
                                              filled: true,
                                              fillColor:
                                                  Color.fromARGB(30, 6, 3, -10),
                                              focusColor: Colors.grey,
                                              border: InputBorder.none,
                                            ),
                                            textAlign: TextAlign.center,
                                            controller: afterAsrTimeController,
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value!.isEmpty &&
                                                  afterTimeVisibility[2]) {
                                                return 'Veuillez saisir une valeur';
                                              }
                                              return null;
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              //WhitelistingTextInputFormatter.digitsOnly
                                              FilteringTextInputFormatter.allow(
                                                  expression)
                                            ],
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                              signed: true,
                                            ),
                                            // Only numbers can be entered
                                          ),
                                        ))
                              ]),
                              Row(children: [
                                const Expanded(flex: 2, child: Text(' المغرب')),
                                Expanded(
                                  flex: 3,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                    ),
                                    child: afterTimeVisibility[3]
                                        ? const Text(
                                            ' بعدالاذان بـ',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18),
                                          )
                                        : const Text(
                                            ' الساعة ',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18),
                                          ),
                                    onPressed: () async {
                                      setState(() {
                                        afterTimeVisibility[3] =
                                            !afterTimeVisibility[3];
                                      });
                                    },
                                  ),
                                ),
                                !afterTimeVisibility[3]
                                    ? Expanded(
                                        flex: 4,
                                        child: Container(
                                            padding: const EdgeInsets.all(15),
                                            height: 50,
                                            child: Center(
                                                child: TextField(
                                              controller: maghribTimeController,
                                              //editing controller of this TextField
                                              decoration: InputDecoration(
                                                hintText:
                                                    prayerTimesManager.maghrib,
                                              ),
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // print(pickedTime.format(context));   //output 10:51 PM
                                                  DateTime parsedTime =
                                                      DateFormat.Hm().parse(
                                                          pickedTime
                                                              .format(context)
                                                              .toString());
                                                  //converting to DateTime so that we can further format on different pattern.
                                                  print(
                                                      parsedTime); //output 1970-01-01 22:53:00.000
                                                  String formattedTime =
                                                      DateFormat('HH:mm')
                                                          .format(parsedTime);
                                                  print(
                                                      formattedTime); //output 14:59:00
                                                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                                                  setState(() {
                                                    maghribTimeController.text =
                                                        formattedTime; //set the value of text field.
                                                  });
                                                } else {
                                                  print("Time is not selected");
                                                }
                                              },
                                            ))),
                                      )
                                    : Expanded(
                                        flex: 3,
                                        child: Visibility(
                                          visible: afterTimeVisibility[3],
                                          child: TextFormField(
                                            enableInteractiveSelection: false,
                                            autofocus: true,
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      2.0, 10.0, 20.0, 8.0),
                                              hintText: ' ',
                                              filled: true,
                                              fillColor:
                                                  Color.fromARGB(30, 6, 3, -10),
                                              focusColor: Colors.grey,
                                              border: InputBorder.none,
                                            ),
                                            textAlign: TextAlign.center,
                                            controller:
                                                afterMaghribTimeController,
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value!.isEmpty &&
                                                  afterTimeVisibility[3]) {
                                                return 'Veuillez saisir une valeur';
                                              }
                                              return null;
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              //WhitelistingTextInputFormatter.digitsOnly
                                              FilteringTextInputFormatter.allow(
                                                  expression)
                                            ],
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                              signed: true,
                                            ),
                                            // Only numbers can be entered
                                          ),
                                        ))
                              ]),
                              Row(children: [
                                const Expanded(flex: 2, child: Text(' العشاء')),
                                Expanded(
                                  flex: 3,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                    ),
                                    child: afterTimeVisibility[4]
                                        ? const Text(
                                            ' بعدالاذان بـ',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18),
                                          )
                                        : const Text(
                                            ' الساعة ',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18),
                                          ),
                                    onPressed: () async {
                                      setState(() {
                                        afterTimeVisibility[4] =
                                            !afterTimeVisibility[4];
                                      });
                                    },
                                  ),
                                ),
                                !afterTimeVisibility[4]
                                    ? Expanded(
                                        flex: 4,
                                        child: Container(
                                            padding: const EdgeInsets.all(15),
                                            height: 50,
                                            child: Center(
                                                child: TextField(
                                              controller: ishaTimeController,
                                              //editing controller of this TextField
                                              decoration: InputDecoration(
                                                hintText:
                                                    prayerTimesManager.isha,
                                              ),
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // print(pickedTime.format(context));   //output 10:51 PM
                                                  DateTime parsedTime =
                                                      DateFormat.Hm().parse(
                                                          pickedTime
                                                              .format(context)
                                                              .toString());
                                                  //converting to DateTime so that we can further format on different pattern.
                                                  print(
                                                      parsedTime); //output 1970-01-01 22:53:00.000
                                                  String formattedTime =
                                                      DateFormat('HH:mm')
                                                          .format(parsedTime);
                                                  print(
                                                      formattedTime); //output 14:59:00
                                                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                                                  setState(() {
                                                    ishaTimeController.text =
                                                        formattedTime; //set the value of text field.
                                                  });
                                                } else {
                                                  print("Time is not selected");
                                                }
                                              },
                                            ))),
                                      )
                                    : Expanded(
                                        flex: 3,
                                        child: Visibility(
                                          visible: afterTimeVisibility[4],
                                          child: TextFormField(
                                            enableInteractiveSelection: false,
                                            autofocus: true,
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      2.0, 10.0, 20.0, 8.0),
                                              hintText: ' ',
                                              filled: true,
                                              fillColor:
                                                  Color.fromARGB(30, 6, 3, -10),
                                              focusColor: Colors.grey,
                                              border: InputBorder.none,
                                            ),
                                            textAlign: TextAlign.center,
                                            controller: afterIshaTimeController,
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value!.isEmpty &&
                                                  afterTimeVisibility[4]) {
                                                return 'Veuillez saisir une valeur';
                                              }
                                              return null;
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              //WhitelistingTextInputFormatter.digitsOnly
                                              FilteringTextInputFormatter.allow(
                                                  expression)
                                            ],
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                              signed: true,
                                            ),
                                            // Only numbers can be entered
                                          ),
                                        ))
                              ]),
                              isCheckedJoumoua
                                  ? Row(children: [
                                      const Expanded(
                                          flex: 2, child: Text(' الجمعة')),
                                      //  const Expanded(child: Text('الساعة ')),

                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                            padding: const EdgeInsets.all(15),
                                            height: 50,
                                            child: Center(
                                                child: TextField(
                                              controller: joumouaTimeController,
                                              //editing controller of this TextField
                                              decoration: const InputDecoration(
                                                  // icon: Icon(Icons.timer), //icon of text field
                                                  //labelText: "Enter Time" ,
                                                  ),
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // print(pickedTime.format(context));   //output 10:51 PM
                                                  DateTime parsedTime =
                                                      DateFormat.Hm().parse(
                                                          pickedTime
                                                              .format(context)
                                                              .toString());
                                                  //converting to DateTime so that we can further format on different pattern.
                                                  print(
                                                      parsedTime); //output 1970-01-01 22:53:00.000
                                                  String formattedTime =
                                                      DateFormat('HH:mm')
                                                          .format(parsedTime);
                                                  print(
                                                      formattedTime); //output 14:59:00
                                                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                                                  setState(() {
                                                    joumouaTimeController.text =
                                                        formattedTime; //set the value of text field.
                                                  });
                                                } else {
                                                  print("Time is not selected");
                                                }
                                              },
                                            ))),
                                      ),
                                    ])
                                  : Container(),
                              isCheckedAid
                                  ? Row(children: [
                                      const Expanded(
                                          flex: 2, child: Text(' العيد')),
                                      //  const Expanded(child: Text('الساعة ')),

                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                            padding: const EdgeInsets.all(15),
                                            height: 50,
                                            child: Center(
                                                child: TextField(
                                              controller: aidTimeController,
                                              //editing controller of this TextField
                                              decoration: const InputDecoration(
                                                  // icon: Icon(Icons.timer), //icon of text field
                                                  // labelText: "Enter Time" ,
                                                  ),
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // print(pickedTime.format(context));   //output 10:51 PM
                                                  DateTime parsedTime =
                                                      DateFormat.Hm().parse(
                                                          pickedTime
                                                              .format(context)
                                                              .toString());
                                                  //converting to DateTime so that we can further format on different pattern.
                                                  print(
                                                      parsedTime); //output 1970-01-01 22:53:00.000
                                                  String formattedTime =
                                                      DateFormat('HH:mm')
                                                          .format(parsedTime);
                                                  print(
                                                      formattedTime); //output 14:59:00
                                                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                                                  setState(() {
                                                    aidTimeController.text =
                                                        formattedTime; //set the value of text field.
                                                  });
                                                } else {
                                                  print("Time is not selected");
                                                }
                                              },
                                            ))),
                                      ),
                                    ])
                                  : Container(),
                              isCheckedTahajod
                                  ? Row(children: [
                                      const Expanded(
                                          flex: 2, child: Text(' التهجد')),
                                      //  const Expanded(child: Text('الساعة ')),

                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                            padding: const EdgeInsets.all(15),
                                            height: 50,
                                            child: Center(
                                                child: TextField(
                                              controller: tahajodTimeController,
                                              //editing controller of this TextField
                                              decoration: const InputDecoration(
                                                  // icon: Icon(Icons.timer), //icon of text field
                                                  // labelText: "Enter Time" ,
                                                  ),
                                              readOnly: true,
                                              //set it true, so that user will not able to edit text
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                  initialTime: TimeOfDay.now(),
                                                  context: context,
                                                );

                                                if (pickedTime != null) {
                                                  // print(pickedTime.format(context));   //output 10:51 PM
                                                  DateTime parsedTime =
                                                      DateFormat.Hm().parse(
                                                          pickedTime
                                                              .format(context)
                                                              .toString());
                                                  //converting to DateTime so that we can further format on different pattern.
                                                  print(
                                                      parsedTime); //output 1970-01-01 22:53:00.000
                                                  String formattedTime =
                                                      DateFormat('HH:mm')
                                                          .format(parsedTime);
                                                  print(
                                                      formattedTime); //output 14:59:00
                                                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                                                  setState(() {
                                                    tahajodTimeController.text =
                                                        formattedTime; //set the value of text field.
                                                  });
                                                } else {
                                                  print("Time is not selected");
                                                }
                                              },
                                            ))),
                                      ),
                                    ])
                                  : Container(),
                            ])),
                      ))
                ],
              )
              :Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Center(
                      child: Text(
                        'SAISR HEURE IQAMA',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                      )),
                  Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: SizedBox(
                        height: 450,
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ListView(children: [
                              Text(f.format(DateTime.now()),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Row(
                                children: [
                                  const Text(' مسجد',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  Text(': ${masjidNameController.text}'),
                                ],
                              ),
                              Row(children: [
                                const Expanded(flex: 2, child: Text(' الفجر')),
                                //  const Expanded(child: Text('الساعة ')),
                                Expanded(
                                  flex: 3,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                    ),
                                    child: afterTimeVisibility[0]
                                        ? const Text(
                                      ' بعدالاذان بـ',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18),
                                    )
                                        : const Text(
                                      ' الساعة ',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        afterTimeVisibility[0] =
                                        !afterTimeVisibility[0];
                                      });
                                    },
                                  ),
                                ),
                                !afterTimeVisibility[0]
                                    ? Expanded(
                                  flex: 4,
                                  child: Container(
                                      padding: const EdgeInsets.all(15),
                                      height: 50,
                                      child: Center(
                                          child: TextField(
                                            controller: fajrTimeController,
                                            //editing controller of this TextField
                                            decoration: InputDecoration(
                                              hintText:
                                              prayerTimesManager.fajr,
                                              // icon: Icon(Icons.timer), //icon of text field
                                              //labelText: "Enter Time" ,
                                            ),
                                            readOnly: true,
                                            //set it true, so that user will not able to edit text
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                              await showTimePicker(
                                                initialTime: TimeOfDay.now(),
                                                context: context,
                                              );

                                              if (pickedTime != null) {
                                                // print(pickedTime.format(context));   //output 10:51 PM
                                                DateTime parsedTime =
                                                DateFormat.Hm().parse(
                                                    pickedTime
                                                        .format(context)
                                                        .toString());
                                                //converting to DateTime so that we can further format on different pattern.
                                                print(
                                                    parsedTime); //output 1970-01-01 22:53:00.000
                                                String formattedTime =
                                                DateFormat('HH:mm')
                                                    .format(parsedTime);
                                                print(
                                                    formattedTime); //output 14:59:00
                                                //DateFormat() is from intl package, you can format the time on any pattern you need.

                                                setState(() {
                                                  fajrTimeController.text =
                                                      formattedTime; //set the value of text field.
                                                });
                                              } else {
                                                print("Time is not selected");
                                              }
                                            },
                                          ))),
                                )
                                    : Expanded(
                                  flex: 3,
                                  child: Visibility(
                                    visible: afterTimeVisibility[0],

                                    child: TextFormField(
                                      enableInteractiveSelection: false,
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(
                                            2.0, 10.0, 20.0, 8.0),
                                        hintText: ' ',
                                        filled: true,
                                        fillColor:
                                        Color.fromARGB(30, 6, 3, -10),
                                        focusColor: Colors.grey,
                                        border: InputBorder.none,
                                      ),
                                      textAlign: TextAlign.center,
                                      controller: afterFajrTimeController,
                                      onChanged: (value) {},
                                      validator: (value) {
                                        if (value!.isEmpty &&
                                            afterTimeVisibility[0]) {
                                          return 'Veuillez saisir une valeur';
                                        }
                                        return null;
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        //WhitelistingTextInputFormatter.digitsOnly
                                        FilteringTextInputFormatter.allow(
                                            expression)
                                      ],
                                      keyboardType: const TextInputType
                                          .numberWithOptions(
                                        signed: true,
                                      ),
                                      // Only numbers can be entered
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                const Expanded(flex: 2, child: Text(' الظهر')),
                                //  const Expanded(child: Text('الساعة ')),
                                Expanded(
                                  flex: 3,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                    ),
                                    child: afterTimeVisibility[1]
                                        ? const Text(
                                      ' بعدالاذان بـ',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18),
                                    )
                                        : const Text(
                                      ' الساعة ',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        afterTimeVisibility[1] =
                                        !afterTimeVisibility[1];
                                      });
                                    },
                                  ),
                                ),
                                !afterTimeVisibility[1]
                                    ? Expanded(
                                  flex: 4,
                                  child: Container(
                                      padding: const EdgeInsets.all(15),
                                      height: 50,
                                      child: Center(
                                          child: TextField(
                                            controller: dhuhrTimeController,
                                            //editing controller of this TextField
                                            decoration: InputDecoration(
                                              hintText:
                                              prayerTimesManager.dhuhr,
                                            ),
                                            readOnly: true,
                                            //set it true, so that user will not able to edit text
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                              await showTimePicker(
                                                initialTime: TimeOfDay.now(),
                                                context: context,
                                              );

                                              if (pickedTime != null) {
                                                // print(pickedTime.format(context));   //output 10:51 PM
                                                DateTime parsedTime =
                                                DateFormat.Hm().parse(
                                                    pickedTime
                                                        .format(context)
                                                        .toString());
                                                //converting to DateTime so that we can further format on different pattern.
                                                print(
                                                    parsedTime); //output 1970-01-01 22:53:00.000
                                                String formattedTime =
                                                DateFormat('HH:mm')
                                                    .format(parsedTime);
                                                print(
                                                    formattedTime); //output 14:59:00
                                                //DateFormat() is from intl package, you can format the time on any pattern you need.

                                                setState(() {
                                                  dhuhrTimeController.text =
                                                      formattedTime; //set the value of text field.
                                                });
                                              } else {
                                                print("Time is not selected");
                                              }
                                            },
                                          ))),
                                )
                                    : Expanded(
                                    flex: 3,
                                    child: Visibility(
                                      visible: afterTimeVisibility[1],
                                      child: TextFormField(
                                        enableInteractiveSelection: false,
                                        autofocus: true,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                          EdgeInsets.fromLTRB(
                                              2.0, 10.0, 20.0, 8.0),
                                          hintText: ' ',
                                          filled: true,
                                          fillColor:
                                          Color.fromARGB(30, 6, 3, -10),
                                          focusColor: Colors.grey,
                                          border: InputBorder.none,
                                        ),
                                        textAlign: TextAlign.center,
                                        controller:
                                        afterDhuhrTimeController,
                                        onChanged: (value) {},
                                        validator: (value) {
                                          if (value!.isEmpty &&
                                              afterTimeVisibility[1]) {
                                            return 'Veuillez saisir une valeur';
                                          }
                                          return null;
                                        },
                                        inputFormatters: <
                                            TextInputFormatter>[
                                          //WhitelistingTextInputFormatter.digitsOnly
                                          FilteringTextInputFormatter.allow(
                                              expression)
                                        ],
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          signed: true,
                                        ),
                                        // Only numbers can be entered
                                      ),
                                    ))
                              ]),
                              Row(children: [
                                const Expanded(flex: 2, child: Text(' العصر')),
                                //  const Expanded(child: Text('الساعة ')),
                                Expanded(
                                  flex: 3,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                    ),
                                    child: afterTimeVisibility[2]
                                        ? const Text(
                                      ' بعدالاذان بـ',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18),
                                    )
                                        : const Text(
                                      ' الساعة ',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        afterTimeVisibility[2] =
                                        !afterTimeVisibility[2];
                                      });
                                    },
                                  ),
                                ),
                                !afterTimeVisibility[2]
                                    ? Expanded(
                                  flex: 4,
                                  child: Container(
                                      padding: const EdgeInsets.all(15),
                                      height: 50,
                                      child: Center(
                                          child: TextField(
                                            controller: asrTimeController,
                                            //editing controller of this TextField
                                            decoration: InputDecoration(
                                              hintText:
                                              prayerTimesManager.asr,
                                            ),
                                            readOnly: true,
                                            //set it true, so that user will not able to edit text
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                              await showTimePicker(
                                                initialTime: TimeOfDay.now(),
                                                context: context,
                                              );

                                              if (pickedTime != null) {
                                                // print(pickedTime.format(context));   //output 10:51 PM
                                                DateTime parsedTime =
                                                DateFormat.Hm().parse(
                                                    pickedTime
                                                        .format(context)
                                                        .toString());
                                                //converting to DateTime so that we can further format on different pattern.
                                                print(
                                                    parsedTime); //output 1970-01-01 22:53:00.000
                                                String formattedTime =
                                                DateFormat('HH:mm')
                                                    .format(parsedTime);
                                                print(
                                                    formattedTime); //output 14:59:00
                                                //DateFormat() is from intl package, you can format the time on any pattern you need.

                                                setState(() {
                                                  asrTimeController.text =
                                                      formattedTime; //set the value of text field.
                                                });
                                              } else {
                                                print("Time is not selected");
                                              }
                                            },
                                          ))),
                                )
                                    : Expanded(
                                    flex: 3,
                                    child: Visibility(
                                      visible: afterTimeVisibility[2],
                                      child: TextFormField(
                                        enableInteractiveSelection: false,
                                        autofocus: true,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                          EdgeInsets.fromLTRB(
                                              2.0, 10.0, 20.0, 8.0),
                                          hintText: ' ',
                                          filled: true,
                                          fillColor:
                                          Color.fromARGB(30, 6, 3, -10),
                                          focusColor: Colors.grey,
                                          border: InputBorder.none,
                                        ),
                                        textAlign: TextAlign.center,
                                        controller: afterAsrTimeController,
                                        onChanged: (value) {},
                                        validator: (value) {
                                          if (value!.isEmpty &&
                                              afterTimeVisibility[2]) {
                                            return 'Veuillez saisir une valeur';
                                          }
                                          return null;
                                        },
                                        inputFormatters: <
                                            TextInputFormatter>[
                                          //WhitelistingTextInputFormatter.digitsOnly
                                          FilteringTextInputFormatter.allow(
                                              expression)
                                        ],
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          signed: true,
                                        ),
                                        // Only numbers can be entered
                                      ),
                                    ))
                              ]),
                              Row(children: [
                                const Expanded(flex: 2, child: Text(' المغرب')),
                                Expanded(
                                  flex: 3,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                    ),
                                    child: afterTimeVisibility[3]
                                        ? const Text(
                                      ' بعدالاذان بـ',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18),
                                    )
                                        : const Text(
                                      ' الساعة ',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        afterTimeVisibility[3] =
                                        !afterTimeVisibility[3];
                                      });
                                    },
                                  ),
                                ),
                                !afterTimeVisibility[3]
                                    ? Expanded(
                                  flex: 4,
                                  child: Container(
                                      padding: const EdgeInsets.all(15),
                                      height: 50,
                                      child: Center(
                                          child: TextField(
                                            controller: maghribTimeController,
                                            //editing controller of this TextField
                                            decoration: InputDecoration(
                                              hintText:
                                              prayerTimesManager.maghrib,
                                            ),
                                            readOnly: true,
                                            //set it true, so that user will not able to edit text
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                              await showTimePicker(
                                                initialTime: TimeOfDay.now(),
                                                context: context,
                                              );

                                              if (pickedTime != null) {
                                                // print(pickedTime.format(context));   //output 10:51 PM
                                                DateTime parsedTime =
                                                DateFormat.Hm().parse(
                                                    pickedTime
                                                        .format(context)
                                                        .toString());
                                                //converting to DateTime so that we can further format on different pattern.
                                                print(
                                                    parsedTime); //output 1970-01-01 22:53:00.000
                                                String formattedTime =
                                                DateFormat('HH:mm')
                                                    .format(parsedTime);
                                                print(
                                                    formattedTime); //output 14:59:00
                                                //DateFormat() is from intl package, you can format the time on any pattern you need.

                                                setState(() {
                                                  maghribTimeController.text =
                                                      formattedTime; //set the value of text field.
                                                });
                                              } else {
                                                print("Time is not selected");
                                              }
                                            },
                                          ))),
                                )
                                    : Expanded(
                                    flex: 3,
                                    child: Visibility(
                                      visible: afterTimeVisibility[3],
                                      child: TextFormField(
                                        enableInteractiveSelection: false,
                                        autofocus: true,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                          EdgeInsets.fromLTRB(
                                              2.0, 10.0, 20.0, 8.0),
                                          hintText: ' ',
                                          filled: true,
                                          fillColor:
                                          Color.fromARGB(30, 6, 3, -10),
                                          focusColor: Colors.grey,
                                          border: InputBorder.none,
                                        ),
                                        textAlign: TextAlign.center,
                                        controller:
                                        afterMaghribTimeController,
                                        onChanged: (value) {},
                                        validator: (value) {
                                          if (value!.isEmpty &&
                                              afterTimeVisibility[3]) {
                                            return 'Veuillez saisir une valeur';
                                          }
                                          return null;
                                        },
                                        inputFormatters: <
                                            TextInputFormatter>[
                                          //WhitelistingTextInputFormatter.digitsOnly
                                          FilteringTextInputFormatter.allow(
                                              expression)
                                        ],
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          signed: true,
                                        ),
                                        // Only numbers can be entered
                                      ),
                                    ))
                              ]),
                              Row(children: [
                                const Expanded(flex: 2, child: Text(' العشاء')),
                                Expanded(
                                  flex: 3,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                    ),
                                    child: afterTimeVisibility[4]
                                        ? const Text(
                                      ' بعدالاذان بـ',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18),
                                    )
                                        : const Text(
                                      ' الساعة ',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        afterTimeVisibility[4] =
                                        !afterTimeVisibility[4];
                                      });
                                    },
                                  ),
                                ),
                                !afterTimeVisibility[4]
                                    ? Expanded(
                                  flex: 4,
                                  child: Container(
                                      padding: const EdgeInsets.all(15),
                                      height: 50,
                                      child: Center(
                                          child: TextField(
                                            controller: ishaTimeController,
                                            //editing controller of this TextField
                                            decoration: InputDecoration(
                                              hintText:
                                              prayerTimesManager.isha,
                                            ),
                                            readOnly: true,
                                            //set it true, so that user will not able to edit text
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                              await showTimePicker(
                                                initialTime: TimeOfDay.now(),
                                                context: context,
                                              );

                                              if (pickedTime != null) {
                                                // print(pickedTime.format(context));   //output 10:51 PM
                                                DateTime parsedTime =
                                                DateFormat.Hm().parse(
                                                    pickedTime
                                                        .format(context)
                                                        .toString());
                                                //converting to DateTime so that we can further format on different pattern.
                                                print(
                                                    parsedTime); //output 1970-01-01 22:53:00.000
                                                String formattedTime =
                                                DateFormat('HH:mm')
                                                    .format(parsedTime);
                                                print(
                                                    formattedTime); //output 14:59:00
                                                //DateFormat() is from intl package, you can format the time on any pattern you need.

                                                setState(() {
                                                  ishaTimeController.text =
                                                      formattedTime; //set the value of text field.
                                                });
                                              } else {
                                                print("Time is not selected");
                                              }
                                            },
                                          ))),
                                )
                                    : Expanded(
                                    flex: 3,
                                    child: Visibility(
                                      visible: afterTimeVisibility[4],
                                      child: TextFormField(
                                        enableInteractiveSelection: false,
                                        autofocus: true,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                          EdgeInsets.fromLTRB(
                                              2.0, 10.0, 20.0, 8.0),
                                          hintText: ' ',
                                          filled: true,
                                          fillColor:
                                          Color.fromARGB(30, 6, 3, -10),
                                          focusColor: Colors.grey,
                                          border: InputBorder.none,
                                        ),
                                        textAlign: TextAlign.center,
                                        controller: afterIshaTimeController,
                                        onChanged: (value) {},
                                        validator: (value) {
                                          if (value!.isEmpty &&
                                              afterTimeVisibility[4]) {
                                            return 'Veuillez saisir une valeur';
                                          }
                                          return null;
                                        },
                                        inputFormatters: <
                                            TextInputFormatter>[
                                          //WhitelistingTextInputFormatter.digitsOnly
                                          FilteringTextInputFormatter.allow(
                                              expression)
                                        ],
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          signed: true,
                                        ),
                                        // Only numbers can be entered
                                      ),
                                    ))
                              ]),

                            ])),
                      ))
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
              child: widget.masjid.type== 'MASJID'?
              Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemCount: _loadedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              _loadedImages.values.elementAt(index),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete_forever),
                                    onPressed: () {
                                      setState(() {
                                        String name =
                                            _loadedImages.keys.elementAt(index);
                                        _toDeleteImages.add(name);
                                        _loadedImages.remove(_loadedImages.keys
                                            .elementAt(index));
                                      });
                                    },
                                  ))
                            ],
                          );
                        }),
                  ),
                  TextButton(
                      onPressed: () {
                        selectImages();
                      },
                      child: const Text('Ajouter 3 photos de la mosquée')),
                  SizedBox(
                    height: 150,
                    child: GridView.builder(
                        itemCount: _selectedImages.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                File(_selectedImages[index].path),
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete_forever),
                                    onPressed: () {
                                      setState(() {
                                        _selectedImages.removeAt(index);
                                      });
                                    },
                                  ))
                            ],
                          );
                        }),
                  ),
                ],
              )
              :Container(),
            )),
        Step(
            state:
                _activeStepIndex <= 4 ? StepState.disabled : StepState.complete,
            isActive: _activeStepIndex >= 4,
            title: const Text(''),
            content: Form(
              key: _formKeys[4],
              child: widget.masjid.type== 'MASJID'?
              Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemCount: _loadedDoc.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              _loadedDoc.values.elementAt(index),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete_forever),
                                    onPressed: () {
                                      setState(() {
                                        String name =
                                            _loadedDoc.keys.elementAt(index);
                                        _toDeleteDocs.add(name);
                                        _loadedDoc.remove(
                                            _loadedDoc.keys.elementAt(index));
                                      });
                                    },
                                  ))
                            ],
                          );
                        }),
                  ),
                  TextButton(
                      onPressed: () {
                        selectDoc();
                      },
                      child: const Text(
                          'Ajouter une copie du document justificatif')),
                  SizedBox(
                    height: 150,
                    child: GridView.builder(
                        itemCount: _selectedDoc.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                File(_selectedDoc[index].path),
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete_forever),
                                    onPressed: () {
                                      setState(() {
                                        _selectedDoc.removeAt(index);
                                      });
                                    },
                                  ))
                            ],
                          );
                        }),
                  ),
                ],
              ):Container(),
            )),
        Step(
            state: StepState.complete,
            isActive: _activeStepIndex >= 5,
            title: const Text(''),
            content: Form(
              key: _formKeys[5],
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
                  Text(responsibleController.text!=''? 'Nom:    ${responsibleController.text}'
                      : '',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(masjidNameController.text != ''? 'Nom de la mosquée: ${masjidNameController.text}'
                      :'',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),

                  Text(addressController.text != '' ? 'Adresse: ${addressController.text}'
                      :'',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Pays: $countryValue',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Gouvernorat: $stateValue',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  placemarks != null
                      ? Column(
                          children: [
                            Text(
                                'Ville sur carte google: ${placemarks![0].country.toString()}',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Pays sur carte google: ${placemarks![0].locality.toString()}',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 5,
                  ),
                  widget.masjid.type== 'MASJID'?  SizedBox(
                    height: 250,
                    child: Column(
                      children: [
                        Text(
                            'Nbre d\'images : ${_selectedImages.length + _loadedImages.length + _selectedDoc.length + _selectedImages.length}'),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemCount: _loadedImages.length,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          _loadedImages.values.elementAt(index),
                                        ],
                                      );
                                    }),
                              ),
                              Expanded(
                                child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemCount: _loadedDoc.length,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          _loadedDoc.values.elementAt(index),
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _selectedImages.isNotEmpty
                                  ? Expanded(
                                      child: GridView.builder(
                                          itemCount: _selectedImages.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Image.file(
                                              File(_selectedImages[index].path),
                                              fit: BoxFit.cover,
                                            );
                                          }),
                                    )
                                  : Container(),
                              _selectedDoc.isNotEmpty
                                  ? Expanded(
                                      child: GridView.builder(
                                          itemCount: _selectedDoc.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Image.file(
                                              File(_selectedDoc[index].path),
                                              fit: BoxFit.cover,
                                            );
                                          }),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: LinearProgressIndicator(
                                      backgroundColor: Colors.teal[100],
                                      color: Colors.teal,
                                      value: _progress,
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Téléchargement photos ${(_progress * 100).toInt()}%',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: LinearProgressIndicator(
                                      backgroundColor: Colors.teal[100],
                                      color: Colors.teal,
                                      value: _progressDoc,
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Téléchargement document ${(_progressDoc * 100).toInt()}%',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                      :Container()
                ],
              ),
            ))
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier les parametres d\'un mosqué'),
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
          return !isLastStep
              ? Row(
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
                                    bool success2 = await updateMasjid();

                                    if (success2) {
                                      if (!mounted) return;
                                      UtilsMasjid.goToWithReplacement(
                                          context, const HomePage());
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
                )
              : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Retour'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(child: buildCustomButton()),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                );
          ;
        },
      ),
    );
  }

  Widget buildCustomButton() {
    var progressTextButton = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          saved ? "Recommencer le téléchargement" : "Enregistrer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: const Text(
          "Loading",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.fail: const Text(
          "Fail",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: const Text(
          "Success",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        )
      },
      stateColors: {
        ButtonState.idle: Colors.blue.shade300,
        ButtonState.loading: Colors.grey.shade400,
        ButtonState.fail: Colors.red.shade300,
        ButtonState.success: Colors.green.shade400,
      },
      onPressed: onPressedCustomButton,
      state: stateOnlyText,
      padding: const EdgeInsets.all(8.0),
    );
    return progressTextButton;
  }

  void onPressedCustomButton() async {
    switch (stateOnlyText) {
      case ButtonState.idle:
        setState(() {
          stateOnlyText = ButtonState.loading;
        });
        if (!saved) {
          saved = await updateMasjid().whenComplete(() async {
            //uploadFile();
            //uploadDoc();
            await loadImages();
            await loadDocs();
            await deleteFile();
            await deleteDoc();

            bool filesUploaded = await uploadFile();
            bool docUploaded = await uploadDoc();

            if (filesUploaded && docUploaded) {
              setState(() {
                stateOnlyText = ButtonState.success;
              });
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Adhan()),
              );
            }
          });
        }
        if (saved) {
        } else {
          setState(() {
            stateOnlyText = ButtonState.idle;
          });
        }
        break;
      case ButtonState.loading:
      case ButtonState.success:
      case ButtonState.fail:
        return;
    }

    setState(() {});
  }

  Future<bool> deleteFile() async {
    bool deleted = true;
    if (_toDeleteImages.isNotEmpty) {
      _toDeleteImages.forEach((element) async {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child(widget.masjid.id)
            .child("images")
            .child(element);
        try {
          await ref.delete();
        } catch (e) {
          deleted = false;
        }
      });
    }
    return deleted;
  }

  Future<bool> deleteDoc() async {
    bool deleted = true;
    if (_toDeleteDocs.isNotEmpty) {
      _toDeleteDocs.forEach((element) async {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child(widget.masjid.id)
            .child("documents")
            .child(element);
        try {
          await ref.delete();
        } catch (e) {
          deleted = false;
        }
      });
    }
    return deleted;
  }

  Future<bool> updateMasjid() async {
    bool success = false;
    await FirebaseFirestore.instance
        .collection('masjids')
        .doc(widget.masjid.id)
        .update({
      "type":dropdownValue,
      "responsibleName": responsibleController.text,
      "address": addressController.text,
      "name": masjidNameController.text,
      "country": countryValue,
      "city": cityValue,
      "state": stateValue,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "fajr": afterTimeVisibility[0]
          ? {
              'fixed': !afterTimeVisibility[0],
              'time': afterFajrTimeController.text
            }
          : {
              'fixed': !afterTimeVisibility[0],
              'time': fajrTimeController.text != ''
                  ? fajrTimeController.text
                  : prayerTimesManager.fajr
            },
      "dhuhr": afterTimeVisibility[1]
          ? {
              'fixed': !afterTimeVisibility[1],
              'time': afterDhuhrTimeController.text
            }
          : {
              'fixed': !afterTimeVisibility[1],
              'time': dhuhrTimeController.text != ''
                  ? dhuhrTimeController.text
                  : prayerTimesManager.dhuhr
            },
      "asr": afterTimeVisibility[2]
          ? {
              'fixed': !afterTimeVisibility[2],
              'time': afterAsrTimeController.text
            }
          : {
              'fixed': !afterTimeVisibility[3],
              'time': asrTimeController.text != ''
                  ? asrTimeController.text
                  : prayerTimesManager.asr
            },
      "maghrib": afterTimeVisibility[3]
          ? {
              'fixed': !afterTimeVisibility[3],
              'time': afterMaghribTimeController.text
            }
          : {
              'fixed': !afterTimeVisibility[3],
              'time': maghribTimeController.text != ''
                  ? maghribTimeController.text
                  : prayerTimesManager.maghrib
            },
      "isha": afterTimeVisibility[4]
          ? {
              'fixed': !afterTimeVisibility[4],
              'time': afterIshaTimeController.text
            }
          : {
              'fixed': !afterTimeVisibility[4],
              'time': ishaTimeController.text != ''
                  ? ishaTimeController.text
                  : prayerTimesManager.isha
            },
      "joumoua": joumouaTimeController.text,
      "aid": aidTimeController.text,
      "tahajod": tahajodTimeController.text,
      "existJoumoua": isCheckedJoumoua,
      "existAid": isCheckedAid,
      "existTahajod": isCheckedTahajod,
      "handicapPass": isCheckedHandicapPass,
      "ablution": isCheckedAblution,
      "womenMousalla": isCheckedWomanMousalla,
      "carPark": isCheckedCarPark,
      'positionMasjid': GeoPoint(_center.latitude, _center.longitude),
    });
    return success;
  }

  void
  selectImages() async {
    final List<XFile> selectedImages =
        await imagePicker.pickMultiImage(imageQuality: 20);
    if (selectedImages.isNotEmpty) {
      _selectedImages.addAll(selectedImages);
    }
    setState(() {});
  }

  Future<bool> checkUploadFiles() async {
    bool uploadCompleted = true;
    if (_selectedImages.isNotEmpty) {
      setState(() {
        _progress = imageUploaded / _selectedImages.length;
      });
    }

    if (imageUploaded < _selectedImages.length) {
      uploadCompleted = false;
    }

    if (!uploadCompleted) {
      await Future.delayed(const Duration(milliseconds: 50));
      uploadCompleted = await checkUploadFiles();
    }

    //await new Future.delayed(const Duration(seconds: 2));
    return uploadCompleted;
  }

  Future<bool> checkUploadDocs() async {
    bool uploadCompleted = true;
    if (_selectedDoc.isNotEmpty) {
      setState(() {
        _progressDoc = docUploaded / _selectedDoc.length;
      });
    }
    if (docUploaded < _selectedDoc.length) {
      uploadCompleted = false;
    }
    if (!uploadCompleted) {
      await Future.delayed(const Duration(milliseconds: 50));
      uploadCompleted = await checkUploadDocs();
    }

    //await new Future.delayed(const Duration(seconds: 2));
    return uploadCompleted;
  }

  Future<bool> uploadFile() async {
    bool saved = true;
    if (_selectedImages.isNotEmpty) {
      _selectedImages.forEach((element) async {
        File file = File(element.path);
        //Todo rondomize name(duplicates?)
        String imageName = file.path.split("/").last;
        Reference ref = FirebaseStorage.instance
            .ref()
            .child(widget.masjid.id)
            .child("images")
            .child(imageName);
        try {
          await ref.putFile(file).whenComplete(() {
            imageUploaded++;
          });
        } catch (e) {
          saved = false;
        }
      });
      await checkUploadFiles();
    }
    return saved;
  }

  Future<bool> uploadDoc() async {
    bool saved = true;
    if (_selectedDoc.isNotEmpty) {
      _selectedDoc.forEach((element) async {
        File file = File(element.path);
        //Todo rondomize name(duplicates?)
        String imageName = file.path.split("/").last;
        Reference ref = FirebaseStorage.instance
            .ref()
            .child(widget.masjid.id)
            .child("documents")
            .child(imageName);
        try {
          await ref.putFile(file).whenComplete(() {
            docUploaded++;
          });
        } catch (e) {
          saved = false;
        }
      });
      await checkUploadDocs();
    }
    return saved;
  }

  void selectDoc() async {
    final List<XFile> selectedImages =
        await imagePicker.pickMultiImage(imageQuality: 20);
    if (selectedImages.isNotEmpty) {
      _selectedDoc.addAll(selectedImages);
    }
    setState(() {});
  }

  Future<void> loadImages() async {
    await FirebaseStorage.instance
        .ref()
        .child(widget.masjid.id)
        .child("images")
        .listAll()
        .then((value) {
      value.items.forEach((element) async {
        _loadedImages[element.name] =
            Image.network(await element.getDownloadURL());
      });
    });
  }

  Future<void> loadDocs() async {
    await FirebaseStorage.instance
        .ref()
        .child(widget.masjid.id)
        .child("documents")
        .listAll()
        .then((value) {
      value.items.forEach((element) async {
        _loadedDoc[element.name] =
            Image.network(await element.getDownloadURL());
      });
    });
  }
}
