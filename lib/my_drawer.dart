import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prayertime/adhan.dart';
import 'package:prayertime/class/hive_masjid.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/display_on_tv/display_on_tv.dart';
import 'package:prayertime/geo_location.dart';
import 'package:prayertime/login/login.dart';
import 'package:prayertime/login/new_register.dart';
import 'package:prayertime/quibla/qibla_direction.dart';
import 'package:prayertime/services/masjid_services.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isLoading = false;
  var mainMasjidsBox = Hive.box<HiveMasjid>('mainMasjid');

  MyMasjid? mainMasjid;

  void getMainMasjid(hiveMainMasjid) {
    if (mainMasjid == null || hiveMainMasjid.id != mainMasjid!.id) {
      mainMasjid = null;
      setState(() {
        isLoading = true;
      });
      if (hiveMainMasjid != null) {
        MasjidService.getMasjidWithId(hiveMainMasjid.id).then((value) {
          mainMasjid = value;
          setState(() {
            isLoading = false;
          });
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
          children: [
            Text('')
            // Icon(Icons.mosque,size: 100,color: Colors.indigo[700],),
          ],
        ),
      ),
      Container(
        color: Colors.indigo[100],
        child: Column(
          children: [
            ListTile(
              title: const Text(
                'Creer un nouveau compte',
                style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
              leading: const Icon(
                Icons.account_box,
                size: 40,
                color: Colors.indigo,
              ),
              // trailing: Icon(Icons.hot_tub),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewRegister()),
                );
              },
            ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DisplayOnTV(
                            mainMasjid: mainMasjid,
                          )),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Se connecter',
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
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
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
              },
            ),
            ListTile(
              title: const Text(
                '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
              onTap: () {},
            ),
            ListTile(
              title: const Text(
                '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
              onTap: () {},
            ),
            ListTile(
              title: const Text(
                '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
              onTap: () {},
            ),
            ListTile(
              title: const Text(
                '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
              onTap: () {},
            ),
            ListTile(
              title: const Text(
                '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
              onTap: () {},
            ),
          ],
        ),
      )
    ]));
  }
}
