// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:Tasks/models/Todo.dart';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;
  var doneTodos = <Todo>[].obs;
  var scheduledTodos = <Todo>[].obs;
  var todayTodos = <Todo>[].obs;

  getDoneTodos() {
    doneTodos.assignAll(todos.where((e) => e.done == true).toList());
  }

  getScheduledTodos() {
    scheduledTodos.assignAll(todos.where((e) => e.dateAndTimeEnabled == true && e.date != '' && e.time != ''));
  }

  getTodayTodos() {
    todayTodos.assignAll(todos.where((e) => e.date == DateFormat("MM/dd/yyyy").format(DateTime.now())));
  }

  @override
  void onInit() {
    List? storedTodos = GetStorage().read<List>('todos');
    
    if (storedTodos != null) {
      todos.assignAll(storedTodos.map((e) => Todo.fromJson(e)).toList());
    }
    ever(todos, (_) {
      GetStorage().write('todos', todos.toList());
    });
    super.onInit();
  }
}
