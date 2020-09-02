import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:simple_android_alarm_manager/ui/home_page.dart';
import 'package:simple_android_alarm_manager/utils/background_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BackgroundService.initializeIsolate();
  AndroidAlarmManager.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Background Task',
      home: HomePage(title: 'Simple Background Task'),
    );
  }
}
