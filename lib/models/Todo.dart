// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  int? id;
  String? title;
  String? details;
  String? date;
  String? time;
  bool? dateAndTimeEnabled;
  bool? done;
  Timestamp? dateCreated;

  Todo(
      {this.id,
      this.title,
      this.details,
      this.date,
      this.time,
      this.dateAndTimeEnabled,
      this.done,
      this.dateCreated,
      });

  Todo.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json['title'];
    details = json['details'];
    date = json['date'];
    time = json['time'];
    done = json['done'];
    dateAndTimeEnabled = json['dateAndTimeEnabled'];
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'date': date,
      'time': time,
      'dateAndTimeEnabled': dateAndTimeEnabled,
      'done': done,
      'dateCreated': dateCreated,
    };
  }
}
