
import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:adhan/adhan.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prayertime/common/prayer_times.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/landing_page.dart';
import 'package:prayertime/location/location.dart';
import 'package:prayertime/login/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';
PrayerTimesManager prayerTimesManager = PrayerTimesManager();




void timerIsolate(SendPort mainToIsolatePort) {
  Timer? _timer;



  void playAdhan() {
    // Add your logic to play the Adhan here
    print('Playing Adhan');
  }

  // Receive messages from the main isolate
  ReceivePort isolateToMainPort = ReceivePort();
  mainToIsolatePort.send(isolateToMainPort.sendPort);

  DateTime now = DateTime.now();
  Prayer nextPrayer = prayerTimesManager.prayerTimes.nextPrayer();
  // Prayer nextPrayer = prayerTimesManager.prayerTimes
  //     .nextPrayerByDateTime(DateTime(now.year, now.month, now.day, 22, 41));
  DateTime? nextPrayerTime;
  if (nextPrayer == Prayer.none) {
    nextPrayerTime = prayerTimesManager.prayerTimesTomorrow.fajr;
  } else {
    nextPrayerTime = prayerTimesManager.prayerTimes.timeForPrayer(nextPrayer)!;
  }
  //nextPrayerTime= DateTime(now.year, now.month, now.day, now.hour, 59, 0,0);


  isolateToMainPort.listen((message) {
    if (message is DateTime) {
      final now = DateTime.now();
      _timer = Timer(nextPrayerTime!.difference(now), playAdhan);
    }
  });
}


const String countKey = 'count';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
ReceivePort port = ReceivePort();

/// Global [SharedPreferences] object.
SharedPreferences? prefs;


void main() async{

  localizationsDelegates: const [
    CountryLocalizations.delegate,  // Pour country_code_picker
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  supportedLocales: const [
  Locale('en'), // Anglais
  Locale('fr'), // Français
  // Ajoutez d'autres langues selon vos besoins
  ];
  WidgetsFlutterBinding.ensureInitialized();
  imageCache.clear();
  await Hive.initFlutter();
 // FlutterIsolate.spawn(timerIsolate(), 'Isolate ready');

  tz.initializeTimeZones();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    name: "PRAYER TIME",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final customTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
   // accentColor: Colors.redAccent,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.00)),
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: 12.50,
        horizontal: 10.00,
      ),
    ),
  );


  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );
  prefs = await SharedPreferences.getInstance();
  if (!prefs!.containsKey(countKey)) {
    await prefs!.setInt(countKey, 0);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(LocationController());
    //Get.put(TimerController());


    return GetMaterialApp(
      title: 'اقامة',
      theme: ThemeData(
        tabBarTheme: const TabBarTheme(
        labelColor: Colors.indigo
        ),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [

        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      home:  const LandingPage(),
    );
  }
}
