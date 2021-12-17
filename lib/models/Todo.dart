// ignore_for_file: file_names

class Todo {
  String title;
  String details;
  String? time;
  bool? done;

  Todo(
      {required this.title,
      required this.details,
      this.time,
      this.done = false});

  factory Todo.fromJson(Map<String, dynamic> json) =>
      Todo(title: json['title'], details: json['details'], done: json['done']);

  Map<String, dynamic> toJson() =>
      {'title': title, 'details': details, 'done': done};
}
