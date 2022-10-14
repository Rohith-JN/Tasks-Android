import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/utils/validators.dart';

class SignUp extends StatefulWidget {
  final VoidCallback onClickedSignIn;
  const SignUp({Key? key, required this.onClickedSignIn}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthController authController = Get.find();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool passwordVisible = true;
  @override
  void dispose() {
    nameController.dispose();
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
                controller: nameController,
                decoration: nameInputDecoration,
                validator: Validator.nameValidator),
          ),
          const SizedBox(height: 15),
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
                  authController.signUp(emailController.text.trim(),
                      passwordController.text, nameController.text, context);
                }
              },
              child: const Text('SIGNUP'),
            ),
          ),
          const SizedBox(height: 30.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("Already have an account? ",
                style: TextStyle(color: secondaryColor, fontSize: 20.0)),
            GestureDetector(
              onTap: widget.onClickedSignIn,
              child: Text(
                'Login',
                style: TextStyle(color: primaryColor, fontSize: 20.0),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
