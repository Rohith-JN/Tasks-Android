import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/utils/routes.dart';
import 'package:tasks/utils/validators.dart';
import 'package:tasks/view/FilteredScreen.dart';

TextFormField primaryTextField(BuildContext context, controller, maxLines,
    maxLength, textInputAction, hintText, style) {
  return TextFormField(
      validator: Validator.titleValidator,
      controller: controller,
      autofocus: true,
      autocorrect: false,
      cursorColor: Colors.grey,
      maxLines: maxLines,
      maxLength: maxLength,
      textInputAction: textInputAction,
      decoration: InputDecoration(
          counterStyle: counterTextStyle,
          hintText: hintText,
          hintStyle: hintTextStyle,
          border: InputBorder.none),
      style: style);
}

Icon primaryIcon(icon) {
  return Icon(
    icon,
    color: const Color(0xFFEAEAEA),
    size: 27.0,
  );
}

Divider primaryDivider = const Divider(
  color: Color(0xFF707070),
  thickness: 1.0,
);

Container primaryButton(VoidCallback function, String title) {
  return Container(
    constraints: const BoxConstraints(maxWidth: 600),
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(9),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor,
            spreadRadius: 5,
            blurRadius: 10,
          ),
          BoxShadow(
            color: primaryColor,
            spreadRadius: -4,
            blurRadius: 5,
          )
        ]),
    width: double.infinity,
    height: 60.0,
    child: ElevatedButton(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle?>(
            const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
        shape: MaterialStateProperty.all<OutlinedBorder?>(
          RoundedRectangleBorder(
              side: const BorderSide(
                  color: Colors.transparent,
                  width: 1,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(9)),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
      ),
      onPressed: function,
      child: Text(title),
    ),
  );
}

Padding secondaryButton(VoidCallback onTap, String title, context) {
  return Padding(
    padding: (MediaQuery.of(context).size.width < 768)
        ? const EdgeInsets.only(right: 0.0)
        : const EdgeInsets.only(right: 15.0),
    child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: tertiaryColor, borderRadius: BorderRadius.circular(14.0)),
          width: 140.0,
          height: 55.0,
          child: Center(
            child: Text(title,
                style: TextStyle(color: primaryColor, fontSize: 23.0)),
          ),
        )),
  );
}

GestureDetector filteredWidget(context, title, infoText, data, icon) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(Routes.route(
          FilteredScreen(
            title: title,
            data: data,
            infoText: infoText,
            icon: icon,
          ),
          const Offset(1.0, 0.0)));
    },
    child: Container(
      width: (MediaQuery.of(context).size.width < 768)
          ? MediaQuery.of(context).size.width * 0.45
          : MediaQuery.of(context).size.width * 0.42,
      height: MediaQuery.of(context).size.height * 0.15,
      decoration: BoxDecoration(
          color: tertiaryColor, borderRadius: BorderRadius.circular(14.0)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Obx(
                () => Text(
                  '${data.length}',
                  style:
                      GoogleFonts.notoSans(fontSize: 40.0, color: primaryColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                title,
                style:
                    GoogleFonts.notoSans(fontSize: 25.0, color: Colors.white),
              ),
            ),
          ]),
    ),
  );
}
