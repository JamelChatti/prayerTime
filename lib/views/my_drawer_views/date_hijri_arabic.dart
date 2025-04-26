import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'dart:ui' as ui;

import 'package:prayertime/common/utils.dart';

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
    month = UtilsMasjid.getMonthHijriInArabic();

}


  @override
  Widget build(BuildContext context) {
    // Obtenir la date hijri actuelle

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Date hijri'),
        ),
        body:
        Directionality(
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

}
