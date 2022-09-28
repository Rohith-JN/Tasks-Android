import 'package:flutter/material.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/authentication/auth.service.dart';
import 'package:tasks/utils/routes.dart';
import 'package:tasks/utils/validators.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool passwordVisible = true;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                Text("TASK", style: headingWhite),
                Text("S", style: headingGreen),
              ],
            ),
            Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: TextFormField(
                        style: formInputText,
                        controller: emailController,
                        decoration: emailInputDecoration,
                        validator: Validator.emailValidator),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: TextFormField(
                        obscureText: passwordVisible,
                        style: formInputText,
                        controller: passwordController,
                        decoration:
                            passwordInputDecoration(passwordVisible, () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        }),
                        validator: Validator.passwordValidator),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(Routes.routeToPassword());
                    },
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child:
                              Text("Forgot Password?", style: paragraphGray)),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    decoration: buttonShadow,
                    width: double.infinity,
                    height: 60.0,
                    child: ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          Authentication.signIn(
                              emailController, passwordController, context);
                        }
                      },
                      child: const Text('LOGIN'),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Don't have an account? ", style: paragraphWhite),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(Routes.routeToSignUp());
                      },
                      child: Text(
                        'Sign Up',
                        style: paragraphGreen,
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
