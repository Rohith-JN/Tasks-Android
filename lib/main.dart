import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/Screens/HomeScreen.dart';
import 'package:todo_app/Screens/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize('resource://drawable/res_app_icon', [
    NotificationChannel(
      channelKey: 'scheduled_channel',
      channelName: 'Scheduled Notification',
      importance: NotificationImportance.High,
      channelShowBadge: true,
      channelDescription: '',
      locked: true,
    )
  ]);
  await GetStorage.init();
  runApp(GetMaterialApp(
    home: const HomeScreen(),
    debugShowCheckedModeBanner: false,
    theme: Themes.light,
    darkTheme: Themes.dark,
    themeMode: ThemeMode.system,
  ));
}
