import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/controllers/authController.dart';
import 'package:tasks/utils/global.dart';
import 'package:tasks/utils/validators.dart';
import 'package:tasks/utils/widgets.dart';

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
          primaryButton(() {
            if (formkey.currentState!.validate()) {
                  authController.signUp(emailController.text.trim(),
                      passwordController.text, nameController.text, context);
                }
          }, 'SIGNUP'),
          const SizedBox(height: 30.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Already have an account? ",
                style: paragraphGray,),
            GestureDetector(
              onTap: widget.onClickedSignIn,
              child: Text(
                'Login',
                style: paragraphPrimary,
              ),
            )
          ]),
        ],
      ),
    );
  }
}
