import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/utils/validators.dart';
import 'package:tasks/utils/widgets.dart';
import '../controllers/authController.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({Key? key}) : super(key: key);

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
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
                Text("S", style: heading(primaryColor)),
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
                  const SizedBox(height: 25),
                  primaryButton(() {
                    if (formkey.currentState!.validate()) {
                      authController.deleteAccount(emailController.text.trim(),
                          passwordController.text.trim(), context);
                    }
                  }, 'Delete Account'),
                  const SizedBox(height: 30.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
