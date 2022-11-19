import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//  Colors

const backgroundColor = Colors.black;
var primaryColor = const Color(0xFF33aaf6);
const secondaryColor = Color(0xFF707070);
const tertiaryColor = Color.fromARGB(255, 37, 37, 37);

// TextStyles

TextStyle appBarTextStyle = GoogleFonts.notoSans(
  fontSize: 30,
  color: primaryColor,
  fontWeight: FontWeight.bold,
);
TextStyle infoTextStyle = const TextStyle(color: Colors.white, fontSize: 23.0);
TextStyle heading(color) =>
    TextStyle(color: color, fontSize: 50.0, fontWeight: FontWeight.bold);
TextStyle formInputText = const TextStyle(color: Colors.white, fontSize: 20);
TextStyle hintTextStyle = const TextStyle(
  color: Color.fromARGB(255, 173, 173, 173),
  fontSize: 20,
);
TextStyle counterTextStyle = const TextStyle(
  color: Color.fromARGB(255, 173, 173, 173),
  fontSize: 15,
);
TextStyle paragraphGray =
    const TextStyle(color: secondaryColor, fontSize: 20.0);
TextStyle paragraphPrimary = TextStyle(color: primaryColor, fontSize: 20.0);

TextStyle paragraphWhiteBig =
    const TextStyle(color: Colors.white, fontSize: 25.0);
TextStyle buttonTextStyleWhite =
    const TextStyle(color: Colors.white, fontSize: 23.0);
TextStyle menuTextStyle =
    const TextStyle(fontSize: 22, color: Color(0xFFEAEAEA));
TextStyle todoScreenStyle = GoogleFonts.notoSans(
  color: const Color(0xFFA8A8A8),
  fontSize: 23.0,
);
TextStyle todoScreenDetailsStyle = GoogleFonts.notoSans(
  color: const Color(0xFFA8A8A8),
  fontSize: 20.0,
);
TextStyle listInfoTextStyle = GoogleFonts.notoSans(
  color: primaryColor,
  fontSize: 23.0,
);
TextStyle actionButtonTextStyle =
    TextStyle(fontSize: 20.0, color: primaryColor);
TextStyle accountTextStyle = const TextStyle(fontSize: 20.0, color: Colors.white);
// Decorations

InputDecoration emailInputDecoration = InputDecoration(
    contentPadding: const EdgeInsets.all(20.0),
    isDense: true,
    focusColor: Colors.transparent,
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(9),
      ),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    filled: true,
    fillColor: const Color.fromARGB(255, 48, 48, 48),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(9),
      ),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    hintText: 'Email',
    hintStyle: hintTextStyle);

InputDecoration nameInputDecoration = InputDecoration(
    contentPadding: const EdgeInsets.all(20.0),
    isDense: true,
    focusColor: Colors.transparent,
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(9),
      ),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    filled: true,
    fillColor: const Color.fromARGB(255, 48, 48, 48),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(9),
      ),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    hintText: 'Name',
    hintStyle: hintTextStyle);

InputDecoration passwordInputDecoration(
        passwordVisible, VoidCallback onPressed) =>
    InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.all(20.0),
        focusColor: Colors.transparent,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(9),
          ),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 48, 48, 48),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(9),
          ),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        hintText: 'password',
        suffixIcon: IconButton(
            splashColor: Colors.transparent,
            icon:
                Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: onPressed),
        hintStyle: hintTextStyle);

TextStyle optionsTextStyle = GoogleFonts.notoSans(
  fontSize: 17.0,
  color: const Color(0xFFEAEAEA),
);

TextStyle todoTitleStyle(condition) => GoogleFonts.notoSans(
      color: const Color(0xFFA8A8A8),
      fontSize: 23.0,
      decoration:
          (condition) ? TextDecoration.lineThrough : TextDecoration.none,
      decorationColor: primaryColor,
      decorationThickness: 2,
    );

//Themes

Theme timePickerTheme(child) => Theme(
      data: ThemeData.dark().copyWith(
        timePickerTheme: TimePickerThemeData(
          backgroundColor: const Color.fromARGB(255, 70, 70, 70),
          dayPeriodTextColor: primaryColor,
          hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
              states.contains(MaterialState.selected)
                  ? Colors.white
                  : Colors.white),
          dialHandColor: primaryColor,
          helpTextStyle: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor),
          dialTextColor: MaterialStateColor.resolveWith((states) =>
              states.contains(MaterialState.selected)
                  ? Colors.white
                  : Colors.white),
          entryModeIconColor: primaryColor,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor:
                  MaterialStateColor.resolveWith((states) => primaryColor)),
        ),
      ),
      child: child!,
    );

Theme datePickerTheme(child) => Theme(
      data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
        surface: primaryColor,
        secondary: primaryColor,
        onPrimary: Colors.white,
        onSurface: Colors.white,
        primary: primaryColor,
      )),
      child: child!,
    );
