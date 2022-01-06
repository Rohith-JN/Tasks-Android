import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/Screens/MainScreen.dart';
import 'package:todo_app/widgets/themes.dart';
import 'package:todo_app/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await GetStorage.init();
  runApp(GetMaterialApp(
    home: const MainScreen(),
    debugShowCheckedModeBanner: false,
    theme: Themes.light,
    darkTheme: Themes.dark,
    themeMode: ThemeMode.system,
  ));
}
