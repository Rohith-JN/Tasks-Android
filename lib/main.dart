import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Screens/HomeScreen.dart';
import 'package:todo_app/Screens/TodoScreen.dart';
import 'package:todo_app/Screens/themes.dart';

void main() async {
  await GetStorage.init();
  runApp(GetMaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
    theme: Themes.light,
    darkTheme: Themes.dark,
    themeMode: ThemeMode.system,
  ));
}
