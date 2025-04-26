import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/common/utils.dart';
import 'dart:ui' as ui;

import 'package:prayertime/class/user.dart';

class UpdateIqamaTime extends StatefulWidget {
  final MyUser user;
  final MyMasjid masjid;

  const UpdateIqamaTime({
    Key? key,
    required this.user,
    required this.masjid,
  }) : super(key: key);

  @override
  State<UpdateIqamaTime> createState() => _UpdateIqamaTimeState();
}

class _UpdateIqamaTimeState extends State<UpdateIqamaTime> {
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
  TextEditingController fajrTimeController = TextEditingController();

  PrayerTimesManager prayerTimesManager = PrayerTimesManager();

  List<bool> afterTimeVisibility = [false, false, false, false, false];
  var expression = RegExp('([-]?)([0-9]+)');
  bool isCheckedJoumoua = false;
  bool isCheckedTahajod = false;
  bool isCheckedAid = false;
  static final f = DateFormat('kk:mm          dd-MM-yyyy');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDescription();
  }

  void getDescription() async {
    fajrTimeController.text = widget.masjid.fajr.time;
    dhuhrTimeController.text = widget.masjid.dhuhr.time;
    asrTimeController.text = widget.masjid.asr.time;
    maghribTimeController.text = widget.masjid.maghrib.time;
    ishaTimeController.text = widget.masjid.isha.time;

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
    isCheckedJoumoua = widget.masjid.existJoumoua;
    isCheckedTahajod = widget.masjid.existTahajod;
    isCheckedAid = widget.masjid.existAid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تغيير أوقات الاقامة'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Center(
                child: Text(
              'تحديد أوقات الاقامة',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold),
            )),
            Directionality(
                textDirection: ui.TextDirection.rtl,
                child: SizedBox(
                  height: 600,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView(children: [
                        Text(f.format(DateTime.now()),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        Row(
                          children: [
                            const Text(' مسجد',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(': ${widget.masjid.name}'),
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
                                          color: Colors.blue, fontSize: 18),
                                    )
                                  : const Text(
                                      ' الساعة ',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 18),
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
                                          hintText: prayerTimesManager.fajr,
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
                                                DateFormat.Hm().parse(pickedTime
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
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
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
                                          color: Colors.blue, fontSize: 18),
                                    )
                                  : const Text(
                                      ' الساعة ',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 18),
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
                                          hintText: prayerTimesManager.dhuhr,
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
                                                DateFormat.Hm().parse(pickedTime
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
                                      controller: afterDhuhrTimeController,
                                      onChanged: (value) {},
                                      validator: (value) {
                                        if (value!.isEmpty &&
                                            afterTimeVisibility[1]) {
                                          return 'Veuillez saisir une valeur';
                                        }
                                        return null;
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        //WhitelistingTextInputFormatter.digitsOnly
                                        FilteringTextInputFormatter.allow(
                                            expression)
                                      ],
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
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
                                          color: Colors.blue, fontSize: 18),
                                    )
                                  : const Text(
                                      ' الساعة ',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 18),
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
                                          hintText: prayerTimesManager.asr,
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
                                                DateFormat.Hm().parse(pickedTime
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
                                      controller: afterAsrTimeController,
                                      onChanged: (value) {},
                                      validator: (value) {
                                        if (value!.isEmpty &&
                                            afterTimeVisibility[2]) {
                                          return 'Veuillez saisir une valeur';
                                        }
                                        return null;
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        //WhitelistingTextInputFormatter.digitsOnly
                                        FilteringTextInputFormatter.allow(
                                            expression)
                                      ],
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
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
                                          color: Colors.blue, fontSize: 18),
                                    )
                                  : const Text(
                                      ' الساعة ',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 18),
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
                                          hintText: prayerTimesManager.maghrib,
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
                                                DateFormat.Hm().parse(pickedTime
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
                                      controller: afterMaghribTimeController,
                                      onChanged: (value) {},
                                      validator: (value) {
                                        if (value!.isEmpty &&
                                            afterTimeVisibility[3]) {
                                          return 'Veuillez saisir une valeur';
                                        }
                                        return null;
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        //WhitelistingTextInputFormatter.digitsOnly
                                        FilteringTextInputFormatter.allow(
                                            expression)
                                      ],
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
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
                                          color: Colors.blue, fontSize: 18),
                                    )
                                  : const Text(
                                      ' الساعة ',
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 18),
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
                                          hintText: prayerTimesManager.isha,
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
                                                DateFormat.Hm().parse(pickedTime
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
                                      controller: afterIshaTimeController,
                                      onChanged: (value) {},
                                      validator: (value) {
                                        if (value!.isEmpty &&
                                            afterTimeVisibility[4]) {
                                          return 'Veuillez saisir une valeur';
                                        }
                                        return null;
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        //WhitelistingTextInputFormatter.digitsOnly
                                        FilteringTextInputFormatter.allow(
                                            expression)
                                      ],
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                        signed: true,
                                      ),
                                      // Only numbers can be entered
                                    ),
                                  ))
                        ]),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(children: [
                          const Expanded(flex: 2, child: Text(' الجمعة')),
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
                                      DateTime parsedTime = DateFormat.Hm()
                                          .parse(pickedTime
                                              .format(context)
                                              .toString());
                                      //converting to DateTime so that we can further format on different pattern.
                                      print(
                                          parsedTime); //output 1970-01-01 22:53:00.000
                                      String formattedTime = DateFormat('HH:mm')
                                          .format(parsedTime);
                                      print(formattedTime); //output 14:59:00
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
                          Checkbox(
                            value: isCheckedJoumoua,
                            onChanged: (value) {
                              setState(() {
                                isCheckedJoumoua = value!;
                              });
                            },
                          ),
                        ]),
                        Row(children: [
                          const Expanded(flex: 2, child: Text(' العيد')),
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
                                      DateTime parsedTime = DateFormat.Hm()
                                          .parse(pickedTime
                                              .format(context)
                                              .toString());
                                      //converting to DateTime so that we can further format on different pattern.
                                      print(
                                          parsedTime); //output 1970-01-01 22:53:00.000
                                      String formattedTime = DateFormat('HH:mm')
                                          .format(parsedTime);
                                      print(formattedTime); //output 14:59:00
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
                          Checkbox(
                            value: isCheckedAid,
                            onChanged: (value) {
                              setState(() {
                                isCheckedAid = value!;
                              });
                            },
                          ),
                        ]),
                        Row(children: [
                          const Expanded(flex: 2, child: Text(' التهجد')),
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
                                      DateTime parsedTime = DateFormat.Hm()
                                          .parse(pickedTime
                                              .format(context)
                                              .toString());
                                      //converting to DateTime so that we can further format on different pattern.
                                      print(
                                          parsedTime); //output 1970-01-01 22:53:00.000
                                      String formattedTime = DateFormat('HH:mm')
                                          .format(parsedTime);
                                      print(formattedTime); //output 14:59:00
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
                          Checkbox(
                            value: isCheckedTahajod,
                            onChanged: (value) {
                              setState(() {
                                isCheckedTahajod = value!;
                              });
                            },
                          ),
                        ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  updateIqamaTimeMasjid();
                                  UtilsMasjid().toastMessage(
                                      "Enregistré avec succés",
                                      Colors.blueAccent);
                                },
                                child: const Text('Valider')),
                            const SizedBox(
                              width: 30,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Quitter',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        )
                      ])),
                )),
          ],
        ),
      ),
    );
  }

  Future<bool> updateIqamaTimeMasjid() async {
    bool success = false;
    await FirebaseFirestore.instance
        .collection('masjids')
        .doc(widget.masjid.id)
        .update({
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
    });
    return success;
  }
}
