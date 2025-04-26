import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/views/my_drawer_views/setting_masjid/introduction_update.dart';
import 'package:prayertime/views/my_drawer_views/setting_masjid/masjid_update.dart';
import 'package:prayertime/views/my_drawer_views/setting_masjid/position_masjid_update.dart';
import 'package:prayertime/views/my_drawer_views/setting_masjid/update_data.dart';
import 'package:prayertime/views/my_drawer_views/setting_masjid/update_iqama_time.dart';
import 'package:prayertime/views/my_drawer_views/setting_masjid/upload_doc.dart';
import 'package:prayertime/class/user.dart';
import 'package:prayertime/views/my_drawer_views/setting_masjid/upload_photo.dart';

class SettingMasjid extends StatefulWidget {
  final MyUser user;
  final MyMasjid masjid;
  const SettingMasjid({Key? key, required this.user,
    required this.masjid,}) : super(key: key);

  @override
  State<SettingMasjid> createState() => _SettingMasjidState();
}

class _SettingMasjidState extends State<SettingMasjid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres de la mosquée') ,
      ),
      body: ListView(children:  [
        ListTile(
        title: const Text('Consulter et modifier '),
        leading: const Icon(LineIcons.pen),
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute<void>(
       builder: (_) => MasjidUpdate(user:widget.user, masjid: widget.masjid)));
        },
      ),
        ListTile(
          title: const Text('Position de la mosquée '),
          leading: const Icon(LineIcons.mapMarker),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => PositionMasjidUpdate(user:widget.user, masjid: widget.masjid)));
          },
        ),
        ListTile(
          title: const Text('Modifier données '),
          leading: const Icon(LineIcons.database),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => UpdateData(user:widget.user, masjid: widget.masjid)));
          },
        ),
        ListTile(
          title: const Text('Modifier heure iqama '),
          leading: const Icon(LineIcons.hourglassHalf),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => UpdateIqamaTime(user:widget.user, masjid: widget.masjid)));
          },
        ),
        ListTile(
          title: const Text('Telecharger Photo '),
          leading: const Icon(LineIcons.image),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => UploadPhoto(user:widget.user, masjid: widget.masjid)));
          },
        ),
        ListTile(
          title: const Text('Telecharger  document '),
          leading: const Icon(LineIcons.dochub),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => UploadDoc(user:widget.user, masjid: widget.masjid)));
          },
        ),

        ListTile(
          title: const Text('Description de la mosquée '),
          leading: const Icon(LineIcons.identificationCard),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => IntroductionUpdate(user:widget.user, masjid: widget.masjid)));
          },
        ),
        ListTile(
          title: const Text('Affichage sur ecran '),
          leading: const Icon(LineIcons.television),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => IntroductionUpdate(user:widget.user, masjid: widget.masjid)));
          },
        )
      ],),
    );
  }
}
