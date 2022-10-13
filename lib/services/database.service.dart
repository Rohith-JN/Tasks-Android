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

  Future<void> addArray(String uid, String title) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("arrays")
          .add({'dateCreated': Timestamp.now(), 'title': title, 'todos': []});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateArray(String uid, String title, String id) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("arrays")
          .doc(id)
          .update({
        'title': title,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteArray(String uid, String id) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("arrays")
          .doc(id)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
