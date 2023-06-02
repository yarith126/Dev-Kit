import 'package:flutter_local_notifications/flutter_local_notifications.dart';

AndroidNotificationDetails _androidNotificationDetails =
    const AndroidNotificationDetails(
  '0',
  '0',
  priority: Priority.max,
  importance: Importance.max,
  enableVibration: true,
);

NotificationDetails _platformChannelSpecifics = NotificationDetails(
  android: _androidNotificationDetails,
  iOS: const DarwinNotificationDetails(),
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class NotificationCon {
  show({required String title, required String body}) {
    return flutterLocalNotificationsPlugin.show(
        0, title, body, _platformChannelSpecifics);
  }
}
