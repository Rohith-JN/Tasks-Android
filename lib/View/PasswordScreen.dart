import 'package:flutter/material.dart';
import 'package:tasks/authentication/auth.service.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/utils/validators.dart';

class Password extends StatefulWidget {
  const Password({Key? key}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
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
                child: backButton(context)),
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
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    decoration: buttonShadow,
                    width: double.infinity,
                    height: 60.0,
                    child: ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          Authentication.resetPassword(
                              context, emailController);
                        }
                      },
                      child: const Text('RESET PASSWORD'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
