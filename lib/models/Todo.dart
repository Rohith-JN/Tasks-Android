// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String? id;
  int? intId;
  String? title;
  String? details;
  String? date;
  String? time;
  bool? dateAndTimeEnabled;
  bool? done;
  Timestamp? dateCreated;

  Todo({
    this.id,
    this.intId,
    this.title,
    this.details,
    this.date,
    this.time,
    this.dateAndTimeEnabled,
    this.done,
    this.dateCreated,
  });

  Todo.fromMap(DocumentSnapshot doc) {
    id = doc.id;
    intId = doc["intId"];
    title = doc['title'];
    details = doc['details'];
    date = doc['date'];
    time = doc['time'];
    done = doc['done'];
    dateAndTimeEnabled = doc['dateAndTimeEnabled'];
    dateCreated = doc['dateCreated'];
  }
}
