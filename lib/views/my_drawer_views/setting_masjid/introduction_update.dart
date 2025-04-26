import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prayertime/common/masjid.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/class/user.dart';
class IntroductionUpdate extends StatefulWidget {
  final MyUser user;
  final MyMasjid masjid;
  const IntroductionUpdate({Key? key, required this.user,
    required this.masjid,}) : super(key: key);

  @override
  State<IntroductionUpdate> createState() => _IntroductionUpdateState();
}

class _IntroductionUpdateState extends State<IntroductionUpdate> {

  TextEditingController _controller =TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDescription();
  }

  void getDescription() async {
   _controller.text = widget.masjid.introduction;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Description du mosquée'),
      ),
      body: ListView(

        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28.0,bottom: 20),
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),

                filled: true,
                icon: Icon(Icons.mosque),
                labelText: 'Description',
                hintText: 'Description',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez saisir le nom du responsable';
                }
                return null;
              },
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                updateIntroductionMasjid();
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
    );
  }

  Future<bool> updateIntroductionMasjid() async {
    bool success = false;
    await FirebaseFirestore.instance
        .collection('masjids')
        .doc(widget.masjid.id)
        .update({
     "introduction":_controller.text
    });
    return success;
  }

}
