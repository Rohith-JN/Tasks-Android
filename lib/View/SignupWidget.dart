import 'package:flutter/material.dart';
import 'package:tasks/Authentication/auth.service.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/utils/validators.dart';
import 'package:tasks/view/MainScreen.dart';

class SignUp extends StatefulWidget {
  final VoidCallback onClickedSignIn;
  const SignUp({Key? key, required this.onClickedSignIn}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
          const SizedBox(height: 40),
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
      const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
  shape: MaterialStateProperty.all<OutlinedBorder?>(
    RoundedRectangleBorder(
        side: const BorderSide(
            color: Colors.transparent, width: 1, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(9)),
  ),
  backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
),
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  Authentication.signUp(
                      emailController, passwordController, context);
                }
              },
              child: const Text('SIGNUP'),
            ),
          ),
          const SizedBox(height: 30.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Already have an account? ", style: paragraphWhite),
            GestureDetector(
              onTap: widget.onClickedSignIn,
              child: Text(
                'Login',
                style: TextStyle(color: primaryColor, fontSize: 25.0),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
