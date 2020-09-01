import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_android_alarm_manager/ui/home_page.dart';
import 'package:simple_android_alarm_manager/utils/background_service.dart';
import 'package:simple_android_alarm_manager/utils/notification_helper.dart';

import 'ui/detail_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BackgroundService.initializeIsolate();
  AndroidAlarmManager.initialize();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await NotificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  NotificationHelper.requestIOSPermissions(flutterLocalNotificationsPlugin);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Background Task',
      home: HomePage(title: 'Simple Background Task'),
      routes: {
        DetailPage.routeName: (context) => DetailPage(),
      },
    );
  }
}
