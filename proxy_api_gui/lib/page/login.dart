import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proxy_api_gui/cubit/login_cubit.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:qlevar_router/qlevar_router.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (previous, current) => current is LoginSuccess,
        listener: (context, state) {
          if (state is LoginSuccess) {
            QR.navigator.replaceAllWithName(AppRouter.main);
          }
        },
        builder: (context, state) {
          return Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Proxy Api",
                    style: Theme.of(context).textTheme.headline1),
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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Password",
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                const SizedBox.square(dimension: 16),
                if (state is LoginFailure) ...[
                  Text(state.message,
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox.square(dimension: 16),
                ],
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  height: 48,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () => context.read<LoginCubit>().login(
                        _emailTextController.text,
                        _passwordTextController.text),
                    child: const Text("Login"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
