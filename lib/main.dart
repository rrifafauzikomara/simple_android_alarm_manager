import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_android_alarm_manager/utils/date_time_helper.dart';
import 'package:simple_android_alarm_manager/utils/notification_helper.dart';

import 'detail_page.dart';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register the UI isolate's SendPort to allow for communication from the
  // background isolate.
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );
  AndroidAlarmManager.initialize();

  notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await NotificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  NotificationHelper.requestIOSPermissions(flutterLocalNotificationsPlugin);
  runApp(MyApp());
}

/// Example app for Espresso plugin.
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(title: 'Flutter Demo Home Page'),
      routes: {
        DetailPage.routeName: (context) => DetailPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // The background
  static SendPort uiSendPort;

  Future<void> _someTask() async {
    await NotificationHelper.showNotification(
        flutterLocalNotificationsPlugin);
    print('Rifa is ---> showed');
  }

  // The callback for our alarm
  static Future<void> callback() async {
    print('Alarm fired!');

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  @override
  void initState() {
    super.initState();

    // Register for events from the background isolate. These messages will
    // always coincide with an alarm firing.
    port.listen((_) async => await _someTask());

    NotificationHelper.configureSelectNotificationSubject(
        context, DetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
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
            await AndroidAlarmManager.oneShotAt(
              DateTimeHelper.format(),
              // Ensure we have a unique alarm ID.
              Random().nextInt(pow(2, 31)),
              callback,
              exact: true,
              wakeup: true,
            );
          },
        ),
      ),
    );
  }
}
