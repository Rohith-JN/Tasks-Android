import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/utils/routes.dart';
import 'package:tasks/utils/validators.dart';
import 'package:tasks/view/PasswordScreen.dart';

class LogIn extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LogIn({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final AuthController authController = Get.find();
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
              Navigator.of(context)
                  .push(Routes.route(const Password(), const Offset(1.0, 0.0)));
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
                borderRadius: const BorderRadius.all(
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
                  authController.signIn(emailController.text.trim(),
                      passwordController.text.trim(), context);
                }
              },
              child: const Text('LOGIN'),
            ),
          ),
          const SizedBox(height: 30.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("Don't have an account? ",
                style: TextStyle(color: secondaryColor, fontSize: 20.0)),
            GestureDetector(
              onTap: widget.onClickedSignUp,
              child: Text(
                'Sign Up',
                style: TextStyle(color: primaryColor, fontSize: 20.0),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
