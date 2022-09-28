import 'package:flutter/material.dart';
import 'package:tasks/view/PasswordScreen.dart';
import 'package:tasks/view/SignupScreen.dart';

class Routes {
  static Route routeToSignUp() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const SignUp(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route routeToPassword() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Password(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
