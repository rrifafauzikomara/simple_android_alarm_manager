import 'dart:isolate';
import 'dart:ui';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static String isolateName = 'isolate';
  static SendPort uiSendPort;

  static void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );
  }

  static Future<void> callback() async {
    print('Alarm fired!');
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  static Future<void> someTask() async {
    print('Updated data from the background isolate');
  }
}
