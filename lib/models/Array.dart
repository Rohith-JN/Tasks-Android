// ignore_for_file: file_names
import 'package:tasks/models/Todo.dart';

class Array {
  String title;
  int id;
  List<Todo>? todos;
  Array({
    required this.title,
    required this.id,
    required this.todos
  });

  factory Array.fromJson(Map<String, dynamic> json) => Array(
      id: json['id'],
      title: json['title'],
      todos: json['todos']
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'todos': todos
      };
}