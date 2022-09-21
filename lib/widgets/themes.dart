// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static final dark = ThemeData.dark().copyWith(
      canvasColor: const Color(0xFF414141),
      splashColor: Colors.transparent,
      // ignore: prefer_const_constructors
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: Color(0xFFEAEAEA)),
      ),
      highlightColor: Colors.transparent,
      hintColor: const Color(0xFFA8A8A8),
      scaffoldBackgroundColor: const Color(0xFF5A5959),
      iconTheme: const IconThemeData(color: Color(0xFFEAEAEA)),
      appBarTheme:
          const AppBarTheme(backgroundColor: Color(0xFF5A5959), elevation: 0),
      textTheme: TextTheme(
        headline1: GoogleFonts.notoSans(
            fontSize: 30,
            color: const Color(0xFFEAEAEA),
            fontWeight: FontWeight.bold),
        headline2: GoogleFonts.notoSans(color: const Color(0xFFEAEAEA)),
        headline3: GoogleFonts.notoSans(color: const Color(0xFFA8A8A8)),
      ));
}

// TextStyles

TextStyle titleStyle = GoogleFonts.notoSans(
  fontSize: 30,
  color: const Color(0xFFEAEAEA),
  fontWeight: FontWeight.bold,
);

TextStyle optionsTextStyle = GoogleFonts.notoSans(
  fontSize: 17.0,
  color: const Color(0xFFEAEAEA),
);

TextStyle alertTextStyle = GoogleFonts.notoSans(
  fontSize: 20.0,
  color: const Color(0xFFEAEAEA),
);

TextStyle todoTitleStyle(condition) => GoogleFonts.notoSans(
    color: const Color(0xFFA8A8A8),
    fontSize: 23.0,
    decoration: (condition) ? TextDecoration.lineThrough : TextDecoration.none);

TextStyle todoDetailsStyle(condition) => GoogleFonts.notoSans(
      color: const Color(0xFFA8A8A8),
      fontSize: 20.0,
      decoration:
          (condition) ? TextDecoration.lineThrough : TextDecoration.none,
    );

TextStyle todoTimeStyle(condition1, condition2) => GoogleFonts.notoSans(
      color: (condition1) ? const Color(0xFFA8A8A8) : Colors.redAccent,
      fontSize: 20.0,
      decoration:
          (condition2) ? TextDecoration.lineThrough : TextDecoration.none,
    );

TextStyle buttonTextStyle =
    const TextStyle(color: Color(0xFFEAEAEA), fontSize: 23.0);

TextStyle menuTextStyle = const TextStyle(fontSize: 22, color: Color(0xFFEAEAEA));
TextStyle menuTextStyleBlue = const TextStyle(fontSize: 20.0, color: Color(0xFF39A7FD));

TextStyle todoScreenStyle = GoogleFonts.notoSans(
      color: const Color(0xFFA8A8A8),
      fontSize: 23.0,
    );

TextStyle todoScreenDetailsStyle = GoogleFonts.notoSans(
      color: const Color(0xFFA8A8A8),
      fontSize: 20.0,
    );
//Other styles

Divider dividerStyle = const Divider(
  color: Color(0xFF707070),
  thickness: 1.0,
);

Icon menuIcon = const Icon(
  Icons.menu,
  color: Color(0xFFEAEAEA),
  size: 27.0,
);
