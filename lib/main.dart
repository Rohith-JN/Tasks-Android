import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Screens/HomeScreen.dart';
import 'package:todo_app/Screens/TodoScreen.dart';

void main() {
  runApp(GetMaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hintColor: Color(0xFFA8A8A8),
        scaffoldBackgroundColor: Color(0xFF5A5959),
        appBarTheme:
            const AppBarTheme(backgroundColor: Color(0xFF5A5959), elevation: 0),
        textTheme: TextTheme(
          headline1: GoogleFonts.notoSans(
              fontSize: 30,
              color: Color(0xFFEAEAEA),
              fontWeight: FontWeight.bold),
          headline2: GoogleFonts.notoSans(color: Color(0xFFEAEAEA)),
        )),
  ));
}
