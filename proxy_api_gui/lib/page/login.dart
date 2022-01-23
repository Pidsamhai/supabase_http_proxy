import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proxy_api_gui/cubit/login_cubit.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:proxy_api_gui/cubit/login_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatefulWidget {
  final Uri? magicLink;
  const LoginPage({Key? key, this.magicLink}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  String get _email => _emailTextController.text;
  String get _password => _passwordTextController.text;
  bool _passwordVisible = true;

  _togglePasswordVisibity() {
    setState(() => _passwordVisible = !_passwordVisible);
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      _emailTextController.text = dotenv.get("TEST_EMAIL", fallback: "");
      _passwordTextController.text = dotenv.get("TEST_PASSWORD", fallback: "");
    }
    if (widget.magicLink != null) {
      context.read<LoginCubit>().magicLinkSingIn(widget.magicLink!);
    }
  }

  @override
  Widget build(BuildContext context) {
    _login() => context.read<LoginCubit>().login(_email, _password);

    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (previous, current) => current is LoginSuccess,
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.goNamed(AppRouter.main);
          }
        },
        builder: (context, state) {
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
                      "Proxy Api",
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
                    if (state is LoginFailure) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "* ${state.message}",
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
                        child: const Text("Login"),
                      ),
                    ),
                    const SizedBox.square(dimension: 4),
                    if (state is LoginLoading) ...[
                      const LinearProgressIndicator(),
                    ],
                    const SizedBox.square(dimension: 4),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        child: Text(
                          "Signup",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () => context.goNamed(AppRouter.signup),
                      ),
                    )
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
