import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks/models/Todo.dart';
import 'package:tasks/models/User.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.id).set({
        "name": user.name,
        "email": user.email,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection("users").doc(uid).get();

      return UserModel.fromDocumentSnapshot(doc);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection("users").doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTodo(String uid, int intId, String title, String details, String date,
      String time, bool dateAndTimeEnabled, bool done) async {
    try {
      await _firestore.collection("users").doc(uid).collection("todos").add({
        'dateCreated': Timestamp.now(),
        'intId': intId,
        'title': title,
        'details': details,
        'date': date,
        'time': time,
        'dateAndTimeEnabled': dateAndTimeEnabled,
        'done': done
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTodo(String uid, String title, String details, String date,
      String time, bool dateAndTimeEnabled, bool done, String id) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("todos")
          .doc(id)
          .update({
        'title': title,
        'details': details,
        'date': date,
        'time': time,
        'dateAndTimeEnabled': dateAndTimeEnabled,
        'done': done
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTodo(String uid, String id) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("todos")
          .doc(id)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
