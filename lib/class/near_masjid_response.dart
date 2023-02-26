import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

//import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:photo_view/photo_view.dart';
import 'package:prayertime/class/hive_masjid.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/introduction_to_the_mosque.dart';
import 'package:prayertime/quibla/loading.dart';
import 'package:prayertime/services/masjid_services.dart';

class NearMasjidResponse extends StatefulWidget {
  Function parentSetState;

  NearMasjidResponse({Key? key, required this.parentSetState})
      : super(key: key);

  @override
  State<NearMasjidResponse> createState() => _NearMasjidResponseState();
}

class _NearMasjidResponseState extends State<NearMasjidResponse> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var myMasjidsBox = Hive.box<HiveMasjid>('myMasjids');
  var mainMasjidsBox = Hive.box<HiveMasjid>('mainMasjid');
  List<MyMasjid> masjids = [];
  MasjidService masjidService = MasjidService();
  Position? _position;
  List<Placemark>? placemarks;
  bool isLoading = true;
  final Map<String, Image> _loadedImages = Map();

  void initMyMasjids() {}

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
    List<MyMasjid> nearestMasjids =
        await masjidService.getNearMasjid(latitude + 5, longitude);
    List<String> myMasjidsIds = myMasjids.map((e) => e.id).toList();
    for (var element in nearestMasjids) {
      masjids.addIf(!myMasjidsIds.contains(element.id), element);
    }
  }

  @override
  void initState() {
    super.initState();
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
    await _getCurrentLocation();
    await getListMasjids();
    await loadImages();
  }

  void putFavMasjid(int index, MyMasjid masjid) {
    if (mainMasjidsBox.isEmpty) {
      mainMasjidsBox.put("mainMasjid", HiveMasjid.fromMyMasjid(masjid));
    }
    myMasjidsBox.put(index, HiveMasjid.fromMyMasjid(masjid));
  }

  void deleteFavMasjid(int index, MyMasjid masjid) {
    myMasjidsBox.delete(index);
    if (mainMasjidsBox.get("mainMasjid")!.id == masjid.id) {
      if (myMasjidsBox.isNotEmpty) {
        mainMasjidsBox.put("mainMasjid", myMasjidsBox.getAt(0)!);
      } else {
        mainMasjidsBox.delete("mainMasjid");
        var x = mainMasjidsBox.get('mainMasjid');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (box.isEmpty) {
    //   return CircularProgressIndicator();
    // }
    return isLoading
        ? LoadingIndicator()
        : masjids.isEmpty
            ? Container()
            : SizedBox(
                height: 500,
                child: ListView.builder(
                  itemCount: masjids.length,
                  itemBuilder: (context, i) {
                    bool favourite = myMasjidsBox.containsKey(i);
                    return ListTile(
                      isThreeLine: true,
                      onTap: () {
                        //TODO delete
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IntroductionToTheMosque(
                                      masjid: masjids[i],
                                    )));
                      },
                      trailing: IconButton(
                          onPressed: () {
                            favMasjid = masjids[i];
                            // if (myMasjidsBox.length == 1) {
                            //   putFavMasjid(i, masjids[i]);
                            //   setState(() {});
                            //   widget.parentSetState();
                            // } else {
                            favourite
                                ? deleteFavMasjid(i, masjids[i])
                                : putFavMasjid(i, masjids[i]);
                            setState(() {});
                            widget.parentSetState();
                            // }
                          },
                          icon: favourite
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
                      leading: _loadedImages[masjids[i].id]==null ?
                      const CircleAvatar(
                          radius: 30,
                        backgroundColor: Colors.indigo,
                          child: Icon(Icons.mosque,size: 40,),
                      )
                      :CircleAvatar(
                        radius: 30,
                        backgroundImage: _loadedImages[masjids[i].id]!.image

                      ),

                      //iconColor: ,
                    );
                    //Text(masjids.elementAt(i)!.name);
                  },
                ),
              );
  }

  Future<void> loadImages() async {
    for (var masjid in masjids) {
      var syncPath= await FirebaseStorage.instance
          .ref()
          .child(masjid.id)
          .child("images")
          .listAll()
          .then((value) async {
            try{
        var image = value.items.first;
        var url = await image.getDownloadURL();
        if(url!=null){
        _loadedImages[masjid.id] = Image.network(url);}}catch(e){
              UtilsMasjid().toastMessage(masjid.name + 'n\'a pas de photo', Colors.red);
      }
      });
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('L\'autorisation de localisation est refusée');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await _determinePosition();
    //print(position.latitude) ;
    //print(position.latitude) ;
    UtilsMasjid.localStorage!.setDouble("latitude", position.latitude);
    UtilsMasjid.localStorage!.setDouble("longitude", position.longitude);
    latitude = position.latitude;
    longitude = position.longitude;
    _position = position;
    LatLng latLng = LatLng(_position!.latitude, _position!.longitude);

    _getPlace(latLng);
  }

  void _getPlace(LatLng position) async {
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
  }

  // Future deleteMasjidFromToken(String id) async{
  //   await _firestore.collection("tokens")
  //       .where("favMasjid",isEqualTo: id)
  //       .delete();
  // }

}
