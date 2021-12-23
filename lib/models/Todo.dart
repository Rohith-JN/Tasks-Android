// ignore_for_file: file_names

class Todo {
  String title;
  String details;
  String? date;
  String? time;
  bool done;
  int? id;

  Todo(
      {required this.title,
      required this.details,
      required this.date,
      required this.time,
      this.id,
      this.done = false});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
      title: json['title'],
      details: json['details'],
      done: json['done'],
      date: json['date'],
      time: json['time'],
      id: json['id']);

  Map<String, dynamic> toJson() => {
        'title': title,
        'details': details,
        'done': done,
        'date': date,
        'time': time,
        'id':'id'
      };
}
