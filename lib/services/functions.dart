import 'package:flutter/cupertino.dart';
import 'package:tasks/services/Notification.service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

tz.TZDateTime parse(date, time) {
  String value = '${date} ${time}';
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

/*
void showNotification() {
  TodoController todoController = Get.put(TodoController());
  for (var i = 0; i < todoController.todos.length; i++) {
    NotificationService().showNotification(
        todoController.todos[i].id,
        'Reminder',
        todoController.todos[i].details,
        parse(todoController.todos[i].date, todoController.todos[i].time));
  }
}
*/