import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/controllers/arrayController.dart';
import 'package:tasks/controllers/userController.dart';
import 'package:tasks/main.dart';
import 'package:tasks/models/User.dart';
import 'package:tasks/services/notification.service.dart';
import 'package:tasks/services/database.service.dart';

import '../utils/global.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> _firebaseUser = Rxn<User>();

  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
  }

  Future signIn(String email, String password, context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) => Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ))));
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Get.find<UserController>().user =
          await Database().getUser(authResult.user!.uid);
      navigatorKey.currentState!.pop(context);
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        backgroundColor: secondaryColor,
        content: Text(e.message!, style: const TextStyle(color: Colors.white)),
      );
      navigatorKey.currentState!.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future signUp(email, password, name, context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) => Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ))));
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      UserModel user =
          UserModel(id: authResult.user!.uid, name: name, email: email);
      if (await Database().createNewUser(user)) {
        Get.find<UserController>().user = user;
      }
      navigatorKey.currentState!.pop(context);
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        backgroundColor: secondaryColor,
        content: Text(e.message!, style: const TextStyle(color: Colors.white)),
      );
      navigatorKey.currentState!.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future resetPassword(context, emailController) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) => Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ))));
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      var snackBar = const SnackBar(
        backgroundColor: secondaryColor,
        content: Text('Password Reset Email Sent',
            style: TextStyle(color: Colors.white)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        backgroundColor: secondaryColor,
        content: Text(e.message!, style: const TextStyle(color: Colors.white)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      navigatorKey.currentState!.pop(context);
    }
  }

  Future signOut(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) => Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ))));
    try {
      await showDialog<String>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 37, 37, 37),
          title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          content: const Text('Are you sure you want to sign out?',
              style: TextStyle(color: Color.fromARGB(255, 187, 187, 187))),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, 'Cancel');
              },
              child: Text('Cancel', style: TextStyle(color: primaryColor)),
            ),
            TextButton(
              onPressed: () async {
                // Todo cancel all notifications
                await _auth.signOut();
                Get.find<UserController>().clear();
                Get.delete<ArrayController>();
                Navigator.pop(context, 'Ok');
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('OK', style: TextStyle(color: primaryColor)),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        backgroundColor: secondaryColor,
        content: Text(e.message!, style: const TextStyle(color: Colors.white)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future deleteAccount(email, password, context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) => Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ))));
    try {
      // Todo cancel all notifications
      Database().deleteUser(_auth.currentUser!.uid);
      AuthCredential authCredential =
          EmailAuthProvider.credential(email: email, password: password);
      UserCredential result =
          await _auth.currentUser!.reauthenticateWithCredential(authCredential);
      await result.user!.delete();
      Get.delete<ArrayController>();

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        backgroundColor: secondaryColor,
        content: Text(e.message!, style: const TextStyle(color: Colors.white)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
