import 'package:flutter/material.dart';
import 'package:proxy_api_gui/widget/password_field.dart';

class ConfirmPasswordForm extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController? passwordConfirmController;
  final Key? formKey;
  const ConfirmPasswordForm({
    Key? key,
    required this.formKey,
    required this.passwordController,
    this.passwordConfirmController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox.square(dimension: 16),
          PasswordField(
            controller: passwordController,
            hint: "Password",
            validator: (value) {
              return ((value?.trim().length ?? 0) < 6)
                  ? 'Password must be greater than 6 digit *'
                  : null;
            },
          ),
          const SizedBox.square(dimension: 16),
          PasswordField(
            controller: passwordConfirmController,
            hint: "Confirm Password",
            validator: (value) {
              return value != passwordController.text
                  ? 'Password not match *'
                  : null;
            },
          ),
        ],
      ),
    );
  }
}
