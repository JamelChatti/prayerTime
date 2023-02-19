import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'dart:ui' as ui;

class DateHijriArabic extends StatefulWidget {
  const DateHijriArabic({Key? key}) : super(key: key);

  @override
  State<DateHijriArabic> createState() => _DateHijriArabicState();
}

class _DateHijriArabicState extends State<DateHijriArabic> {
  HijriCalendar now = HijriCalendar.now();
  String locale = 'ar';
   String? month;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    HijriCalendar.setLocal(locale);
    getMonthHijriInArabic();

}


  @override
  Widget build(BuildContext context) {
    // Obtenir la date hijri actuelle

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Date hijri'),
        ),
        body:Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Center(
            child: Text(
              '${now.hDay.toString().padLeft(2, '0')} ${month} ${now.hYear.toString()}',
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }

  void getMonthHijriInArabic(){
    switch (int.parse(now.hMonth.toString().padLeft(2, '0'))) {
      case 1:
      month = "محرم";
        break;
      case 2:
        month = "صفر";
        break;
      case 3:
        month = "ربيع الأول";
        break;
      case 4:
        month = "ربيع الثاني";
        break;
      case 5:
        month = "جمادى الأول";
        break;
      case 6:
        month = "جمادى الثاني";
        break;
      case 7:
        month = "رجب";
        break;
      case 8:
        month = "شعبان";
        break;
      case 9:
        month = "رمضان";
        break;
      case 10:
        month = "شوال";
        break;
      case 11:
        month = "ذو القعدة";
        break;
      case 12:
        month = "وذو الحجة";
        break;
    }

  }

}
