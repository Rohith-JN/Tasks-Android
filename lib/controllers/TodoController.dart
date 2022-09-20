// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Tasks/models/Todo.dart';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;

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
