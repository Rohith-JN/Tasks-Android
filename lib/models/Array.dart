// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/models/Todo.dart';

class ArrayModel {
  String? title;
  String? id;
  Timestamp? dateCreated;

  ArrayModel({this.title, this.id, this.dateCreated});

  ArrayModel.fromMap(DocumentSnapshot doc) {
    title = doc["title"];
    id = doc.id;
    dateCreated = doc["dateCreated"];
  }
}
