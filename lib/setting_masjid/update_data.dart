import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/user.dart';

class UpdateData extends StatefulWidget {
  final MyUser user;
  final MyMasjid masjid;
  const UpdateData({Key? key, required this.user,
    required this.masjid,}) : super(key: key);

  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {

  final TextEditingController masjidNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController responsibleController = TextEditingController();
  String countryValue = '';
  String stateValue = '';
  String cityValue = '';
  bool isCheckedJoumoua = false;
  bool isCheckedTahajod = false;
  bool isCheckedAid = false;
  bool isCheckedCarPark = false;
  bool isCheckedWomanMousalla = false;
  bool isCheckedHandicapPass = false;
  bool isCheckedAblution = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDescription();
  }


  void getDescription() async {
    responsibleController.text = widget.masjid.responsibleName;
    masjidNameController.text = widget.masjid.name;
    addressController.text = widget.masjid.address;
    cityValue = widget.masjid.city;
    countryValue = widget.masjid.country;
    stateValue = widget.masjid.state;
    isCheckedWomanMousalla = widget.masjid.womenMousalla;
    isCheckedJoumoua = widget.masjid.existJoumoua;
    isCheckedTahajod = widget.masjid.existTahajod;
    isCheckedAid = widget.masjid.existAid;
    isCheckedAblution = widget.masjid.ablution;
    isCheckedCarPark = widget.masjid.carPark;
    isCheckedHandicapPass = widget.masjid.handicapPass;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modification'),
      ),
      body: SizedBox(
        height: 600,
        child: ListView(
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
                              Text('Parking'),
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
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){
                  updateDataMasjid();
                  UtilsMasjid().toastMessage("Enregistré avec succés", Colors.blueAccent);
                }, child: const Text('Valider')),
                const SizedBox(
                  width: 30,
                ),
                TextButton(onPressed: (){
                  Navigator.of(context).pop();
                },   child: const Text('Quitter',style: TextStyle(fontSize: 18),),)
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool> updateDataMasjid() async {
    bool success = false;
    await FirebaseFirestore.instance
        .collection('masjids')
        .doc(widget.masjid.id)
        .update({
      "responsibleName": responsibleController.text,
      "address": addressController.text,
      "name": masjidNameController.text,
      "country": countryValue,
      "city": cityValue,
      "state": stateValue,
      "existJoumoua": isCheckedJoumoua,
      "existAid": isCheckedAid,
      "existTahajod": isCheckedTahajod,
      "handicapPass": isCheckedHandicapPass,
      "ablution": isCheckedAblution,
      "womenMousalla": isCheckedWomanMousalla,
      "carPark": isCheckedCarPark,
    });
    return success;
  }

}
