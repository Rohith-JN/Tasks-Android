// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/models/Todo.dart';

class ArrayModel {
  String? title;
  String? id;
  List<Todo>? todos;
  Timestamp? dateCreated;

  ArrayModel({this.title, this.id, this.todos, this.dateCreated});

  ArrayModel.fromMap(DocumentSnapshot doc) {
    title = doc["title"];
    id = doc.id;
    todos = doc["todos"];
    dateCreated = doc["dateCreated"];
  }
}
