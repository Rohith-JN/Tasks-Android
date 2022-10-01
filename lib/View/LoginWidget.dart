import 'package:flutter/material.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/authentication/auth.service.dart';
import 'package:tasks/utils/routes.dart';
import 'package:tasks/utils/validators.dart';

class LogIn extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LogIn({Key? key, required this.onClickedSignUp}) : super(key: key);

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
    return Form(
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
                decoration: passwordInputDecoration(passwordVisible, () {
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
                  child: Text("Forgot Password?", style: paragraphGray)),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(9),
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor,
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: primaryColor,
                    spreadRadius: -4,
                    blurRadius: 5,
                  )
                ]),
            width: double.infinity,
            height: 60.0,
            child: ElevatedButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle?>(
                    const TextStyle(
                        fontSize: 25.0, fontWeight: FontWeight.bold)),
                shape: MaterialStateProperty.all<OutlinedBorder?>(
                  RoundedRectangleBorder(
                      side: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(9)),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
              ),
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
              onTap: widget.onClickedSignUp,
              child: Text(
                'Sign Up',
                style: TextStyle(color: primaryColor, fontSize: 25.0),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
