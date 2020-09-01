import 'dart:isolate';

import 'dart:ui';

import '../main.dart';
import 'notification_helper.dart';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();

class BackgroundService {
  // The background
  static SendPort uiSendPort;

  static void initializeIsolate() {
    // Register the UI isolate's SendPort to allow for communication from the
    // background isolate.
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );
  }

  // app is open, minimizes, close is work
  // The callback for our alarm
  static Future<void> callback() async {
    print('Alarm fired!');

    await NotificationHelper.showNotification(flutterLocalNotificationsPlugin);

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  // app is open and minimizes is work, app is close not work
  static Future<void> someTask() async {
    print('Rifa is ---> waiting');
    // Ensure we've loaded the updated from the background isolate.
    print('Rifa is ---> showed');
  }
}
