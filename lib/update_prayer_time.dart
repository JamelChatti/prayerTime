import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:prayertime/common/masjid.dart';


class UpdatePrayerTime extends StatefulWidget {
  const UpdatePrayerTime({Key? key}) : super(key: key);

  @override
  State<UpdatePrayerTime> createState() => _UpdatePrayerTimeState();
}

class _UpdatePrayerTimeState extends State<UpdatePrayerTime> {
  TextEditingController fajrController =TextEditingController();
  TextEditingController dhohrController =TextEditingController();
  TextEditingController asrController =TextEditingController();
  TextEditingController maghrebController =TextEditingController();
  TextEditingController ichaController =TextEditingController();
  TextEditingController joumouaController =TextEditingController();
  TextEditingController aidController =TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
List<MyMasjid> massajid = [];
  var expression = RegExp('([-]?)([0-9]+)');
  static final f = DateFormat('dd-MM-yyyy          kk:mm');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.white70,
        title: const Text(''),),
      body:Directionality(
        textDirection: ui.TextDirection.rtl,
        child: SizedBox(height: 600,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(children: [
              Text(f.format(DateTime.now()),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              const Text('اختيار المسجد', style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18)),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _typeAheadController,
                  autofocus: true,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _typeAheadController.clear();
                        setState(() {
                         // getCloseList();
                        });
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return
                    getListMassajid(pattern);
                },
                itemBuilder: (context, MyMasjid suggestion) {
                  return ListTile(
                    //leading: Icon(Icons.shopping_cart),
                    title: Text(suggestion.name),
                    subtitle: Text(suggestion.city),
                  );
                },
                onSuggestionSelected: (MyMasjid suggestion) {

                 // _typeAheadController.clear();
                  //Navigator.of(context).pop();
                },
              ),
              Row(children: [
                const Expanded(child: Text('صلاة الفجر')),
                const Expanded(child: Text('بعدالاذان ب ')),

                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    controller: fajrController,
                    //initialValue: "1",
                    decoration: const InputDecoration(
                      hintText: '',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      //WhitelistingTextInputFormatter.digitsOnly
                      FilteringTextInputFormatter.allow(expression)
                    ], // Only numbers can be entered
                  ),
                ),
                const Expanded(child: Text('د')),

              ],),
              Row(children: [
                const Expanded(child: Text('صلاة الظهر')),
                const Expanded(child: Text('على الساعة ')),


                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    controller: dhohrController,
                    //initialValue: "1",
                    decoration: const InputDecoration(
                      hintText: '',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      //WhitelistingTextInputFormatter.digitsOnly
                      FilteringTextInputFormatter.allow(expression)
                    ], // Only numbers can be entered
                  ),
                ),
                const Expanded(child: Text('د')),

              ],),
              Row(children: [
                const Expanded(child: Text('صلاة العصر')),
                const Expanded(child: Text('بعدالاذان ب ')),

                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    controller: asrController,
                    //initialValue: "1",
                    decoration: const InputDecoration(
                      hintText: '',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      //WhitelistingTextInputFormatter.digitsOnly
                      FilteringTextInputFormatter.allow(expression)
                    ], // Only numbers can be entered
                  ),
                ),
                const Expanded(child: Text('د')),

              ],),
              Row(children: [
                const Expanded(child: Text('صلاة المغرب')),
                const Expanded(child: Text('بعدالاذان ب ')),

                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    controller: maghrebController,
                    //initialValue: "1",
                    decoration: const InputDecoration(
                      hintText: '',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      //WhitelistingTextInputFormatter.digitsOnly
                      FilteringTextInputFormatter.allow(expression)
                    ], // Only numbers can be entered
                  ),
                ),
                const Expanded(child: Text('د')),

              ],),
              Row(children: [
                const Expanded(child: Text('صلاة العشاء')),
                const Expanded(child: Text('بعدالاذان ب ')),

                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    controller: ichaController,
                    //initialValue: "1",
                    decoration: const InputDecoration(
                      hintText: '',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      //WhitelistingTextInputFormatter.digitsOnly
                      FilteringTextInputFormatter.allow(expression)
                    ], // Only numbers can be entered
                  ),
                ),
                const Expanded(child: Text('د')),

              ],),
              Row(children: [
                const Expanded(child: Text('صلاة الجمعة')),
                const Expanded(child: Text('على الساعة ')),


                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    controller: joumouaController,
                    //initialValue: "1",
                    decoration: const InputDecoration(
                      hintText: '',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      //WhitelistingTextInputFormatter.digitsOnly
                      FilteringTextInputFormatter.allow(expression)
                    ], // Only numbers can be entered
                  ),
                ),
              ],),

              Row(children: [
                const Expanded(child: Text('صلاة العيد')),
                const Expanded(child: Text('على الساعة ')),

                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    controller: aidController,
                    //initialValue: "1",
                    decoration: const InputDecoration(
                      hintText: '',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      //WhitelistingTextInputFormatter.digitsOnly
                      FilteringTextInputFormatter.allow(expression)
                    ], // Only numbers can be entered
                  ),
                ),
              ],),




            ],),
          ),
        ),
      ),
    );
  }

  List<MyMasjid> getListMassajid(String value) {
     massajid.clear();
    // for (var element in dataList) {
    //   if (element.name.toLowerCase().startsWith(value.toLowerCase())) {
    //     articles.add(element);
    //     // FocusNode node = FocusNode();
    //     // myFocusNodes.add(node);
    //     // node.requestFocus();
    //   }
    // }
     return massajid;
  }


}
