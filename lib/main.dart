import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prayertime/common/utils.dart';
import 'package:prayertime/landing_page.dart';
import 'package:prayertime/location.dart';
import 'package:prayertime/login/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;


void main() async{
   await Hive.initFlutter();

   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
 // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    name: "PRAYER TIME",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(BaseflowPluginExample(
    pluginName: 'test plugin',
    githubURL: 'https://github.com/baseflow/baseflow_plugin_template',
    pubDevURL: 'https://pub.dev/publishers/baseflow.com/packages',
    pages: [Location.createPage()],
  ));
  tz.initializeTimeZones();
  await Utils.init();

  final customTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    accentColor: Colors.redAccent,
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

      home:  const LandingPage(),
    );
  }
}
