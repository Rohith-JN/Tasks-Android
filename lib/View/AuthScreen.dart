import 'package:flutter/material.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/view/LoginWidget.dart';
import 'package:tasks/view/SignupWidget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  void toggle() => setState(() {
        isLogin = !isLogin;
      });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        height: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("TASK", style: heading(Colors.white)),
                Text("S",
                    style: heading(primaryColor)),
              ],
            ),
            (isLogin)
                ? LogIn(onClickedSignUp: toggle)
                : SignUp(onClickedSignIn: toggle)
          ],
        ),
      ),
    );
  }
}
