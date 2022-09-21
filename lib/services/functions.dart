import 'package:Tasks/services/notification_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import '../controllers/TodoController.dart';

void checkAll() {
  TodoController todoController = Get.put(TodoController());
  for (var i = 0; i < todoController.todos.length; i++) {
    todoController.todos[i].done = true;
  }
  GetStorage().write('todos', todoController.todos.toList());
}

void unCheckAll() {
  TodoController todoController = Get.put(TodoController());
  for (var i = 0; i < todoController.todos.length; i++) {
    todoController.todos[i].done = false;
  }
  GetStorage().write('todos', todoController.todos.toList());
}

Future<AudioPlayer> playLocalAsset() async {
  AudioCache cache = AudioCache();
  return await cache.play("audio.mp3");
}

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

void turnOffSwitch() {
  TodoController todoController = Get.put(TodoController());
  for (var i = 0; i < todoController.todos.length; i++) {
    todoController.todos[i].dateAndTimeEnabled = false;
  }
  GetStorage().write('todos', todoController.todos.toList());
}