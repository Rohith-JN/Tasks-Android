import 'package:form_field_validator/form_field_validator.dart';

class Validator {
  static MultiValidator emailValidator = MultiValidator([
    RequiredValidator(errorText: "* Required"),
    EmailValidator(errorText: "Enter valid email id"),
  ]);
  static MultiValidator passwordValidator = MultiValidator([
    MinLengthValidator(6,
        errorText: "Password should be greater than 6 characters"),
    RequiredValidator(errorText: "* Required"),
    MaxLengthValidator(15,
        errorText: "Password should not be greater than 15 characters")
  ]);
  static MultiValidator titleValidator = MultiValidator([
    RequiredValidator(errorText: "Please enter some text")
  ]);
}
