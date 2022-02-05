import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final String? Function(String? value)? validator;
  const PasswordField({
    Key? key,
    this.controller,
    required this.hint,
    this.validator,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _passwordVisible = true;

  _togglePasswordVisibity() => setState(() {
        _passwordVisible = !_passwordVisible;
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _passwordVisible,
      autocorrect: false,
      enableSuggestions: false,
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.always,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: widget.hint,
          suffixIcon: IconButton(
            onPressed: _togglePasswordVisibity,
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
          )),
      validator: widget.validator,
    );
  }
}
