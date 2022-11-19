import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/utils/validators.dart';
import 'package:tasks/utils/widgets.dart';

class Password extends StatefulWidget {
  const Password({Key? key}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final AuthController authController = Get.find();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Reset Password"),
        centerTitle: true,
        leading: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  splashColor: Colors.transparent,
                  icon: primaryIcon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                )),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 100.0),
        width: double.infinity,
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        height: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Receive an email to reset your password",
              style: paragraphWhiteBig,
              textAlign: TextAlign.center,
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
                  const SizedBox(height: 30),
                  primaryButton(() {
                    if (formkey.currentState!.validate()) {
                      authController.resetPassword(context, emailController);
                    }
                  }, 'RESET PASSWORD')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
