import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proxy_api_gui/cubit/basic_state.dart';
import 'package:proxy_api_gui/cubit/signup_cubit.dart';
import 'package:proxy_api_gui/widget/confirmation_email.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  String get _email => _emailTextController.text;
  String get _password => _passwordTextController.text;
  bool _passwordVisible = true;
  late SignUpCubit _cubit;

  _togglePasswordVisibity() {
    setState(() => _passwordVisible = !_passwordVisible);
  }

  @override
  void initState() {
    super.initState();
    _cubit = SignUpCubit(context.read());
    if (kDebugMode) {
      _emailTextController.text = "user@user.com";
      _passwordTextController.text = "123456";
    }
  }

  @override
  Widget build(BuildContext context) {
    _login() => _cubit.signup(_email, _password);

    return Scaffold(
      body: BlocConsumer<SignUpCubit, BasicState>(
        bloc: _cubit,
        listenWhen: (previous, current) => current is SuccessState,
        listener: (context, state) {
          if (state is SuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Confirmation email sent.")),
            );
          }
        },
        builder: (context, state) {
          if (state is SuccessState) {
            return const ConfirmationEmailWidget();
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Signup",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox.square(dimension: 16),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: TextField(
                        controller: _emailTextController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), hintText: "Email"),
                      ),
                    ),
                    const SizedBox.square(dimension: 16),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: TextField(
                        controller: _passwordTextController,
                        obscureText: _passwordVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "Password",
                            suffixIcon: IconButton(
                              onPressed: _togglePasswordVisibity,
                              icon: Icon(_passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            )),
                        keyboardType: TextInputType.visiblePassword,
                        onSubmitted: (value) => _login(),
                      ),
                    ),
                    const SizedBox.square(dimension: 16),
                    if (state is FailureState) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "* ${state.msg}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox.square(dimension: 16),
                    ],
                    SizedBox(
                      height: 48,
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: _login,
                        child: const Text("Signup"),
                      ),
                    ),
                    const SizedBox.square(dimension: 4),
                    if (state is LoadingState) ...[
                      const LinearProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
