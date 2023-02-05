import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:photo_view/photo_view.dart';
import 'package:prayertime/class/hive_masjid.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/common/masjid.dart';
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
  var myMasjidsBox = Hive.box<HiveMasjid>('myMasjids');
  var mainMasjidsBox = Hive.box<HiveMasjid>('mainMasjid');
  List<MyMasjid> masjids = [];
  MasjidService masjidService = MasjidService();
  Position? _position;
  List<Placemark>? placemarks;
  bool isLoading = false;
  final Map<String, Image> _loadedImages = Map();

  void initMyMasjids() {}

  Future<void> getListMasjids() async {
    masjids = await masjidService.getNearMasjid(latitude + 5, longitude);
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    setState(() {
      isLoading = true;
    });
    bool getLocationDone = false;
    bool getMasjidsDone = false;

    _getCurrentLocation().then((value) {
      getLocationDone = true;
      if (getMasjidsDone && isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    });
    getListMasjids().then((value) {
      getMasjidsDone = true;
      if (getLocationDone && isLoading) {
        if(mounted) {
          setState(() {
          isLoading = false;
        });
        }
      }
    });
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
        mainMasjidsBox.clear();
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
                    //myMasjids.contains(masjids[i]);
                    return ListTile(
                      isThreeLine: true,
                      onTap: () {
                        //TODO delete
                        favMasjid = masjids[i];
                    if(myMasjidsBox.length==1){
                      putFavMasjid(i, masjids[i]);
                      setState(() {});
                      widget.parentSetState();
                    }else{
                        favourite
                            ? deleteFavMasjid(i, masjids[i])
                            : putFavMasjid(i, masjids[i]);
                        setState(() {});
                        widget.parentSetState();
                      }},
                      trailing:
                          favourite ? const Icon(Icons.check) : const Text(''),
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
                      leading: CircleAvatar(
                        radius: 20,
                        child: Padding(
                            padding: EdgeInsets.all(2),
                            child: PhotoView(
                              imageProvider:
                              _loadedImages.values.elementAt(0).image,customSize: Size( MediaQuery.of(context).size.width,  MediaQuery.of(context).size.height*0.48),
                            )),
                      ),

                      //iconColor: ,
                    );
                    //Text(masjids.elementAt(i)!.name);
                  },
                ),
              );
  }

  Future<void> loadImages(int i) async {
    await FirebaseStorage.instance
        .ref()
        .child(masjids[i].id)
        .child("images")
        //.child(imageName)
        .listAll()
        .then((value) {
      value.items.forEach((element) async {
        setState(() {});
      });
    });
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
    Utils.localStorage!.setDouble("latitude", position.latitude);
    Utils.localStorage!.setDouble("longitude", position.longitude);
    latitude = position.latitude;
    longitude = position.longitude;
    _position = position;
    LatLng latLng = LatLng(_position!.latitude, _position!.longitude);

    _getPlace(latLng);
    if (mounted) setState(() {});
  }

  void _getPlace(LatLng position) async {
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
  }
}
