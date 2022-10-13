import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/models/Todo.dart';

class Array {
  String? title;
  String? id;
  Timestamp? dateCreated;
  List<Todo>? todos;

  Array({this.title, this.id, this.dateCreated, this.todos});

  Array.fromMap(DocumentSnapshot doc) {
    title = doc["title"];
    id = doc.id;
    dateCreated = doc["dateCreated"];
    todos = doc['todos']
        .map<Todo>((mapString) => Todo.fromJson(mapString))
        .toList();
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateCreated': dateCreated,
      'title': title,
      'todos': todos!.map((todo) => todo.toJson()).toList(),
    };
  }
}
