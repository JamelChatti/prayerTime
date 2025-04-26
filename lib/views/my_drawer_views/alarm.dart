
import 'dart:developer' as developer;
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:prayertime/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AlarmHomePage extends StatefulWidget {
  const AlarmHomePage({Key? key}) : super(key: key);

  @override
  _AlarmHomePageState createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<AlarmHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    AndroidAlarmManager.initialize();

    // Register for events from the background isolate. These messages will
    // always coincide with an alarm firing.
    port.listen((_) async => await _incrementCounter());
  }

  Future<void> _incrementCounter() async {
    developer.log('Increment counter!');
    // Ensure we've loaded the updated count from the background isolate.
    await prefs?.reload();

    setState(() {
      _counter++;
    });
  }

  // The background
  static SendPort? uiSendPort;

  // The callback for our alarm
  @pragma('vm:entry-point')
  static Future<void> callback() async {
    developer.log('Alarm fired!');
    // Get the previous cached count and increment it.
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(countKey) ?? 0;
    await prefs.setInt(countKey, currentCount + 1);

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }


  void dispose() {
    super.dispose();
    port.close();

  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineMedium;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Android alarm manager plus example'),
        elevation: 4,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Alarm fired $_counter times',
              style: textStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Total alarms fired: ',
                  style: textStyle,
                ),
                Text(
                  prefs?.getInt(countKey).toString() ?? '',
                  key: const ValueKey('BackgroundCountText'),
                  style: textStyle,
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              key: const ValueKey('RegisterOneShotAlarm'),
              onPressed: () async {
                await AndroidAlarmManager.oneShot(
                  const Duration(seconds: 5),
                  // Ensure we have a unique alarm ID.
                  Random().nextInt(pow(2, 31) as int),
                  callback,
                  exact: true,
                  wakeup: true,
                );
              },
              child: const Text(
                'Schedule OneShot Alarm',
              ),
            ),
          ],
        ),
      ),
    );
  }
}