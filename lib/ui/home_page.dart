import 'dart:math';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:simple_android_alarm_manager/utils/background_service.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Register for events from the background isolate. These messages will
    // always coincide with an alarm firing.
    port.listen((_) async => await BackgroundService.someTask());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: RaisedButton(
          child: Text(
            'Schedule OneShot Alarm',
          ),
          key: ValueKey('RegisterOneShotAlarm'),
          onPressed: () async {
            print('Scheduled clicked');
            await AndroidAlarmManager.oneShotAt(
              DateTime.now().add(Duration(seconds: 5)),
              // Ensure we have a unique alarm ID.
              Random().nextInt(pow(2, 31)),
              BackgroundService.callback,
              exact: true,
              wakeup: true,
            );
          },
        ),
      ),
    );
  }
}
