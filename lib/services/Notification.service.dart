import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  
  Future<void> showNotification(
      int id, String? title, String? body, time) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        time,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'Scheduled_channel', 'Scheduled Notification',
                importance: Importance.max, priority: Priority.max)),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}