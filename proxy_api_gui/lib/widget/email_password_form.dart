import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:proxy_api_gui/widget/password_field.dart';

class EmailPasswordForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Key? formKey;
  const EmailPasswordForm({
    Key? key,
    this.formKey,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.always,
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
            validator: (String? value) {
              return !EmailValidator.validate(value ?? "")
                  ? 'Invalid email format *'
                  : null;
            },
          ),
          const SizedBox.square(dimension: 16),
          PasswordField(
            controller: passwordController,
            hint: "Password",
            validator: (value) {
              return ((value?.trim().length ?? 0) < 6)
                  ? 'Password must be greater than 6 digit *'
                  : null;
            },
          )
        ],
      ),
    );
  }
}
