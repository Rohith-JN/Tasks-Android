import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/global.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> _firebaseUser = Rxn<User>();

  String? get user => _firebaseUser.value!.email;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
  }

  Future signIn(emailController, passwordController, context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) => Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ))));
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        backgroundColor: secondaryColor,
        content: Text(e.message!, style: const TextStyle(color: Colors.white)),
      );
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future signUp(emailController, passwordController, context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) => Center(
                child: CircularProgressIndicator(
              color: primaryColor,
            ))));
    Navigator.of(context).pop();
    try {
      await _auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        backgroundColor: secondaryColor,
        content: Text(e.message!, style: const TextStyle(color: Colors.white)),
      );
      Navigator.of(context).pop();
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
      await _auth
          .sendPasswordResetEmail(email: emailController.text);
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
      Navigator.of(context).pop();
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
              child:
                  Text('Cancel', style: TextStyle(color: primaryColor)),
            ),
            TextButton(
              onPressed: () {
                _auth.signOut();
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

  Future deleteAccount(context) async {
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
          title: const Text('Delete account',
              style: TextStyle(color: Colors.white)),
          content: const Text('Are you sure you want to delete your account?',
              style: TextStyle(color: Color.fromARGB(255, 187, 187, 187))),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, 'Cancel');
              },
              child:
                  Text('Cancel', style: TextStyle(color: primaryColor)),
            ),
            TextButton(
              onPressed: () {
                _auth.currentUser!.delete();
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
}