

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static SharedPreferences? localStorage;

  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }



  static goTo(context, page) {
    //SchedulerBinding.instance.addPostFrameCallback((_) {
    Navigator.push(
        context, MaterialPageRoute<void>(builder: (context) => page));
    //});
  }

  static goToWithReplacement(context, page) {
    //SchedulerBinding.instance.addPostFrameCallback((_) {
    Navigator.pushReplacement(
        context, MaterialPageRoute<void>(builder: (context) => page));
    //});
  }

  void toastMessage(String message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }



  List<String> tokens = [];

  void alertDialog(context,String text1,text2,text3,text4,text5,text6,text7,text8,text9){
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title:  Text( text1,
            style: const TextStyle(
                fontSize: 15,
                color: Colors.blue,
                fontWeight: FontWeight.bold),),
          content: Column(
            children: [
              Row(
                children: [
                  Text(text2),
                  Text(text3,
                    style:
                    const TextStyle(fontSize: 15, color: Colors.green),),
                ],
              ),
              Row(
                children: [
                  Text(text4),

                  Text(text5,
                    style:
                    const TextStyle(fontSize: 15, color: Colors.green),),
                ],
              ),
              Row(
                children: [
                  Text(text6),

                  Text(text7,
                    style:
                    const TextStyle(fontSize: 15, color: Colors.green),),
                ],
              ),
              Row(
                children: [
                  Text(text8),
                  Text(text9,
                    style:
                    const TextStyle(fontSize: 15, color: Colors.green),),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),

            ],
          ),
        ));
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

}
