import 'package:cloud_firestore/cloud_firestore.dart';

class FTodo {
  int? id;
  String? docId;
  String? arrayTitle;
  String? title;
  String? details;
  String? date;
  String? time;
  bool? dateAndTimeEnabled;
  bool? done;
  Timestamp? dateCreated;

  FTodo({
    this.id,
    this.docId,
    this.arrayTitle,
    this.title,
    this.details,
    this.date,
    this.time,
    this.dateAndTimeEnabled,
    this.done,
    this.dateCreated,
  });

  FTodo.fromMap(DocumentSnapshot doc) {
    id = doc["id"];
    docId = doc.id;
    arrayTitle = doc["arrayTitle"];
    title = doc['title'];
    details = doc['details'];
    date = doc['date'];
    time = doc['time'];
    done = doc['done'];
    dateAndTimeEnabled = doc['dateAndTimeEnabled'];
    dateCreated = doc['dateCreated'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'docId': docId,
      'arrayTitle': arrayTitle,
      'title': title,
      'details': details,
      'date': date,
      'time': time,
      'dateAndTimeEnabled': dateAndTimeEnabled,
      'done': done,
      'dateCreated': dateCreated
    };
  }
}
