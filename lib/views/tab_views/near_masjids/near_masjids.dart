import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
//import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:prayertime/class/hive_masjid.dart';
import 'package:prayertime/common/HiveBoxesManager.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/views/tab_views/near_masjids/introduction_to_the_mosque.dart';
import 'package:prayertime/common/widgets/loading.dart';
import 'package:prayertime/services/masjid_services.dart';

class NearMasjids extends StatefulWidget {

  NearMasjids({Key? key})
      : super(key: key);

  @override
  State<NearMasjids> createState() => _NearMasjidsState();
}

class _NearMasjidsState extends State<NearMasjids> {
  TextEditingController masjidController = TextEditingController();

  late final Box<HiveMasjid> myMasjidsBox;
  late final Box<HiveMasjid> mainMasjidsBox;

  List<MyMasjid> masjids = [];
  MasjidService masjidService = MasjidService();
  Position? _position;
  List<Placemark>? placemarks;
  bool isLoading = true;
  final Map<String, Image> _loadedImages = Map();
  List<MyMasjid> masjidList = [];

  Future<void> getListMasjids() async {
    masjids.clear();

    // add favourites
    List<MyMasjid> myMasjids = [];
    for (HiveMasjid hiveMasjid in myMasjidsBox.values) {
      MyMasjid? masjid = await MasjidService.getMasjidWithId(hiveMasjid.id);
      if (masjid != null) {
        myMasjids.add(masjid);
      }
    }
    masjids.addAll(myMasjids);

    // add nearest masjids ONLY IF not already added with favourites
    Position position = await UtilsMasjid.determinePosition();
    List<MyMasjid> nearestMasjids =
        await masjidService.getNearMasjid(position.latitude + 5, position.longitude);
    List<String> myMasjidsIds = myMasjids.map((e) => e.id).toList();
    for (var element in nearestMasjids) {
      masjids.addIf(!myMasjidsIds.contains(element.id), element);
    }
  }

  @override
  void initState() {
    super.initState();
    var hiveBoxesManager = HiveBoxesManager();
    myMasjidsBox = hiveBoxesManager.myMasjidsBox;
    mainMasjidsBox = hiveBoxesManager.mainMasjidBox;

    initData().then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> initData() async {
    masjids.clear();
    _loadedImages.clear();
    await getListMasjids();
    await loadImages();
  }

  void putFavMasjid(MyMasjid masjid) {
    if (mainMasjidsBox.isEmpty) {
      mainMasjidsBox.put("mainMasjid", HiveMasjid.fromMyMasjid(masjid));
    }
    myMasjidsBox.put(masjid.id, HiveMasjid.fromMyMasjid(masjid));
  }

  void deleteFavMasjid(MyMasjid masjid) {
    myMasjidsBox.delete(masjid.id);
    if (mainMasjidsBox.get("mainMasjid")!.id == masjid.id) {
      if (myMasjidsBox.isNotEmpty) {
        mainMasjidsBox.put("mainMasjid", myMasjidsBox.getAt(0)!);
      } else {
        mainMasjidsBox.delete("mainMasjid");
      }
    }
  }

  Future<List<MyMasjid>> getMasjidContainingString(String searchString) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('masjids')
        .where('name', isGreaterThanOrEqualTo: searchString)
        .where('name', isLessThan: '$searchString\uf8ff')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((result) {
        masjidList.add(MyMasjid.fromDocument(result));
      });
    });
    return masjidList;
  }

  @override
  Widget build(BuildContext context) {
    // if (box.isEmpty) {
    //   return CircularProgressIndicator();
    // }
    return ListView(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),

            color: Colors.grey,
          ),
          width: 200,
          // color: Colors.grey,
          child: Scrollable(
              viewportBuilder: (BuildContext context, ViewportOffset position) {
            return TypeAheadField(
              controller: masjidController,

              // textFieldConfiguration: TextFieldConfiguration(
              //     controller: masjidController,
              //     style: const TextStyle(fontSize: 15),
              //     onChanged: (value) {
              //       masjidList.clear();
              //       if (value.isNotEmpty) {
              //         getMasjidContainingString(masjidController.text);
              //       }
              //     },
              //    // textCapitalization: TextCapitalization.sentences,
              //
              //     inputFormatters: <TextInputFormatter>[
              //       UpperCaseTextFormatter()
              //     ],
              //
              //     decoration: InputDecoration(
              //
              //       border: InputBorder.none,
              //       icon: const Icon(Icons.search),
              //       suffixIcon: IconButton(
              //         onPressed: () {
              //           masjidController.clear();
              //           masjidList.clear();
              //         },
              //         icon: const Icon(Icons.clear),
              //       ),
              //     )),
              suggestionsCallback: (pattern) async {
                return masjidList;
              },
              itemBuilder: (context, MyMasjid suggestion) {
                return ListTile(
                  title: Text(suggestion.name),
                  subtitle: Text(suggestion.city),
                );
              },
              onSelected: (MyMasjid suggestion) {
                setState(() {});
                // add chips
                masjidController.text = suggestion.name;
                if (myMasjidsBox.values
                    .any((element) => element.id == suggestion.id)) {
                  //myMasjidsBox.add(HiveMasjid.fromMyMasjid(suggestion));
                } else {
                  if (mainMasjidsBox.isEmpty) {
                    mainMasjidsBox.put(
                        "mainMasjid", HiveMasjid.fromMyMasjid(suggestion));
                  }
                  myMasjidsBox.add(HiveMasjid.fromMyMasjid(suggestion));
                }
                setState(() {});
              },
            );
          }),
        ),
        isLoading
            ? LoadingIndicator()
            : masjids.isEmpty
                ? Container()
                : SizedBox(
                    height: 500,
                    child: ListView.builder(
                      itemCount: masjids.length,
                      itemBuilder: (context, i) {
                        bool isFav = myMasjidsBox.containsKey(masjids[i].id);
                        return ListTile(
                          isThreeLine: true,
                          onTap: () {
                            //TODO delete
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IntroductionToTheMosque(
                                          masjid: masjids[i],
                                        )));
                          },
                          trailing: IconButton(
                              onPressed: () {
                                isFav
                                    ? deleteFavMasjid(masjids[i])
                                    : putFavMasjid(masjids[i]);
                                setState(() {});
                                // }
                              },
                              icon: isFav
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.redAccent,
                                    )
                                  : const Icon(
                                      Icons.favorite_border_outlined,
                                      color: Colors.redAccent,
                                    )),
                          title: Text(
                            masjids.elementAt(i).name.trim(),
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${masjids.elementAt(i).address}\n",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue.shade400,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: _loadedImages[masjids[i].id] == null
                              ? const CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.indigo,
                                  child: Icon(
                                    Icons.mosque,
                                    size: 40,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      _loadedImages[masjids[i].id]!.image),

                          //iconColor: ,
                        );
                        //Text(masjids.elementAt(i)!.name);
                      },
                    ),
                  )
      ],
    );
  }

  Future<void> loadImages() async {
    for (var masjid in masjids) {
      var syncPath = await FirebaseStorage.instance
          .ref()
          .child(masjid.id)
          .child("images")
          .listAll()
          .then((value) async {
        try {
          var image = value.items.first;
          var url = await image.getDownloadURL();
          if (url != null) {
            _loadedImages[masjid.id] = Image.network(url);
          }
        } catch (e) {
          UtilsMasjid()
              .toastMessage(masjid.name + 'n\'a pas de photo', Colors.red);
        }
      });
    }
  }


// Future deleteMasjidFromToken(String id) async{
//   await _firestore.collection("tokens")
//       .where("favMasjid",isEqualTo: id)
//       .delete();
// }
}
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}
String capitalize(String value) {
  if(value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}