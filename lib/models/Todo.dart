// ignore_for_file: file_names

class Todo {
  String title;
  String details;
  String? date;
  String? time;
  bool done;
  bool dateAndTimeEnabled;
  int id;
  Todo(
      {required this.title,
      required this.details,
      required this.date,
      required this.time,
      this.dateAndTimeEnabled = false,
      required this.id,
      this.done = false});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
      id: json['id'],
      title: json['title'],
      details: json['details'],
      done: json['done'],
      date: json['date'],
      time: json['time'],
      dateAndTimeEnabled: json['dateAndTimeEnabled']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'details': details,
        'done': done,
        'date': date,
        'time': time,
        'dateAndTimeEnabled': dateAndTimeEnabled
      };
}
