import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasks/services/database.service.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/utils/widgets.dart';
import 'package:tasks/view/DeleteScreen.dart';
import 'package:timezone/timezone.dart' as tz;

class Functions {
  static tz.TZDateTime parse(date, time) {
    String value = '$date $time';
    String currentFormat = "MM/dd/yyyy hh:mm a";
    DateTime? dateTime = DateTime.now();
    if (value != null || value.isNotEmpty) {
      try {
        bool isUtc = false;
        dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();
      } catch (e) {}
    }
    String parsed = dateTime!.toString();
    return tz.TZDateTime.parse(tz.local, parsed);
  }

  static deleteTodo(arrayController, uid, arrayIndex, todoIndex) async {
    Database().deleteAllTodo(
        uid, arrayController.arrays[arrayIndex].todos![todoIndex].id!);
    arrayController.arrays[arrayIndex].todos!.removeAt(todoIndex);
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("arrays")
          .doc(arrayController.arrays[arrayIndex].id)
          .set({
        "title": arrayController.arrays[arrayIndex].title,
        "dateCreated": arrayController.arrays[arrayIndex].dateCreated,
        "todos": arrayController.arrays[arrayIndex].todos!
            .map((todo) => todo.toJson())
            .toList()
      });
    } catch (e) {}
  }

  static deleteArray(uid, arrayController, index) {
    Database().deleteArray(uid, arrayController.arrays[index].id ?? '');
    for (var i = 0; i < arrayController.arrays[index].todos!.length; i++) {
      Database()
          .deleteAllTodo(uid, arrayController.arrays[index].todos![i].id!);
      // Todo Cancel notification at arrayController.arrays[index].todos![i].id!
    }
  }

  static showBottomSheet(context, authController) {
    showModalBottomSheet<void>(
      backgroundColor: tertiaryColor,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(top: 15.0),
          height: 260,
          child: ListView(children: [
            const SizedBox(height: 10.0),
            Center(
              child: Icon(
                Icons.account_circle,
                size: 40.0,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 15.0),
            Center(
                child: Text(
              authController.user!.email ?? '',
              style: accountTextStyle,
            )),
            const SizedBox(height: 15.0),
            primaryDivider,
            ListTile(
              title: Text(
                "Sign out",
                style: optionsTextStyle,
              ),
              leading: Icon(
                Icons.logout,
                color: primaryColor,
              ),
              onTap: () {
                Navigator.pop(context);
                authController.signOut(context);
              },
            ),
            ListTile(
              title: Text(
                "Delete account",
                style: optionsTextStyle,
              ),
              leading: Icon(
                Icons.delete,
                color: primaryColor,
              ),
              onTap: () async {
                Navigator.pop(context);
                await showDialog<String>(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 37, 37, 37),
                    title: const Text('Delete account',
                        style: TextStyle(color: Colors.white)),
                    content: const Text(
                        'Are you sure you want to delete your account?',
                        style: TextStyle(
                            color: Color.fromARGB(255, 187, 187, 187))),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                        child: Text('Cancel',
                            style: TextStyle(color: primaryColor)),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context, 'Ok');
                          Get.to(const DeleteScreen());
                        },
                        child:
                            Text('OK', style: TextStyle(color: primaryColor)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ]),
        );
      },
    );
  }
}
