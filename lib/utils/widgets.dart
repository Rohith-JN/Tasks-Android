import 'package:flutter/material.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/utils/validators.dart';

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
    color: Color(0xFFEAEAEA),
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
