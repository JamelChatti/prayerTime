import 'package:flutter/material.dart';
//import 'package:flutter_qiblah/utils.dart';
import 'package:hive/hive.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prayertime/common/globals.dart';
import 'package:prayertime/services/auth_service.dart';
import 'package:prayertime/views/my_drawer_views/adhan.dart';
import 'package:prayertime/views/my_drawer_views/alarm.dart';
import 'package:prayertime/views/my_drawer_views/date_hijri_arabic.dart';

import 'package:prayertime/class/hive_masjid.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/views/my_drawer_views/display_on_tv/display_on_tv.dart';
import 'package:prayertime/views/my_drawer_views/geo_location.dart';
import 'package:prayertime/login/login.dart';
import 'package:prayertime/login/new_register.dart';
import 'package:prayertime/services/masjid_services.dart';
import 'package:prayertime/views/my_drawer_views/setting_masjid/setting_masjid.dart';
import 'package:prayertime/views/tab_views/quibla/qibla_direction.dart';

import '../../common/login_status_enum.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isLoading = false;
  var mainMasjidsBox = Hive.box<HiveMasjid>('mainMasjid');
  final masjidService = MasjidService();
  MyMasjid? mainMasjid;
  MyMasjid? imamMasjid;

  void getMainMasjid(hiveMainMasjid) {
    if (mainMasjid == null || hiveMainMasjid.id != mainMasjid!.id) {
      mainMasjid = null;
      setState(() {
        isLoading = true;
      });
      if (hiveMainMasjid != null) {
        MasjidService.getMasjidWithId(hiveMainMasjid.id).then((value) {
          mainMasjid = value;
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HiveMasjid? hiveMainMasjid = mainMasjidsBox.get('mainMasjid');

    getMainMasjid(hiveMainMasjid);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: <Widget>[
      Container(
        height: 300,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("images/belle-grande-mosquee-islamique.jpg"),
          fit: BoxFit.cover,
        )),
        //color: Colors.blueGrey[700],
        child: Column(
          children: const [
            Text('')
            // Icon(Icons.mosque,size: 100,color: Colors.indigo[700],),
          ],
        ),
      ),
      Container(
        color: Colors.indigo[100],
        child: Column(
          children: [
            currentUser != null
                ? currentUser!.masjid != null
                    ? ListTile(
                        title: const Text(
                          'Edit Masjid',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.indigo,
                          ),
                        ),
                        leading: const Icon(
                          LineIcons.mosque,
                          size: 40,
                          color: Colors.indigo,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (context) => SettingMasjid(
                                      user: currentUser!,
                                      masjid: currentUser!.masjid!)));
                        },
                      )
                    : Container()
                : Container(),
            ListTile(
              title: const Text(
                'Direction quibla',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.indigo,
                ),
              ),
              leading: const Icon(
                LineIcons.kaaba,
                size: 40,
                color: Colors.indigo,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuiblaDirection()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Ma position',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.indigo,
                ),
              ),
              leading: const Icon(
                Icons.location_on,
                color: Colors.indigo,
                size: 40,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeoLocation()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Affichage sur TV',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.indigo,
                ),
              ),
              leading: const Icon(
                Icons.tv,
                color: Colors.indigo,
                size: 40,
              ),
              onTap: () {
                HiveMasjid? hiveMainMasjid = mainMasjidsBox.get('mainMasjid');
                getMainMasjid(hiveMainMasjid);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => DisplayOnTV(
                //             mainMasjid: mainMasjid,
                //           )),
                // );
              },
            ),
            ListTile(
              title: Text(
                currentUser == null ? 'Se connecter' : 'Se déconnecter',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.indigo,
                ),
              ),
              leading: Icon(
                currentUser == null ? Icons.login : Icons.logout,
                color: Colors.indigo,
                size: 40,
              ),
              onTap: currentUser == null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    }
                  : () {
                      AuthService().signOut();
                      setState(() {});
                    },
            ),
            ListTile(
                title: const Text(
                  'Adhan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.indigo,
                  ),
                ),
                leading: const Icon(
                  Icons.login,
                  color: Colors.indigo,
                  size: 40,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Adhan()),
                  );
                }),
            // ListTile(
            //   title: const Text(
            //     'Alarm',
            //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => AlarmHomePage()),
            //     );
            //   },
            // ),
          ],
        ),
      )
    ]));
  }
}
