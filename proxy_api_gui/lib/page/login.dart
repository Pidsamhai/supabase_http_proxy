import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proxy_api_gui/cubit/basic_state.dart';
import 'package:proxy_api_gui/cubit/login_cubit.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:proxy_api_gui/theme/theme.dart';
import 'package:proxy_api_gui/utils/custom_icons.dart';
import 'package:proxy_api_gui/widget/email_password_form.dart';
import 'package:proxy_api_gui/widget/link_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  final Uri? magicLink;
  const LoginPage({Key? key, this.magicLink}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  String get _email => _emailTextController.text;
  String get _password => _passwordTextController.text;
  late LoginCubit _cubit;

  bool get _formIsValid => _formKey.currentState?.validate() == true;

  _rebuilder() => setState(() => {});

  @override
  void initState() {
    super.initState();
    _cubit = LoginCubit(context.read());
    if (kDebugMode) {
      _emailTextController.text = dotenv.get("TEST_EMAIL", fallback: "");
      _passwordTextController.text = dotenv.get("TEST_PASSWORD", fallback: "");
    }
    if (widget.magicLink != null) {
      _cubit.magicLinkSingIn(widget.magicLink!);
    }
    _emailTextController.addListener(_rebuilder);
    _passwordTextController.addListener(_rebuilder);
  }

  @override
  void dispose() {
    super.dispose();
    _emailTextController.removeListener(_rebuilder);
    _passwordTextController.removeListener(_rebuilder);
  }

  @override
  Widget build(BuildContext context) {
    _login() => _cubit.login(_email, _password);

    return Scaffold(
      body: BlocConsumer<LoginCubit, BasicState>(
        bloc: _cubit,
        listenWhen: (previous, current) => current is SuccessState,
        listener: (context, state) {
          if (state is SuccessState) {
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
                    EmailPasswordForm(
                      formKey: _formKey,
                      emailController: _emailTextController,
                      passwordController: _passwordTextController,
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
                        onPressed: (state is LoadingState || !_formIsValid)
                            ? null
                            : _login,
                        child: const Text("Login"),
                      ),
                    ),
                    const SizedBox.square(dimension: 4),
                    if (state is LoadingState) ...[
                      const LinearProgressIndicator(),
                    ],
                    const SizedBox.square(dimension: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style:
                                socialLoginButtonStyle(const Color(0xFF333333)),
                            onPressed: () =>
                                _cubit.providerLogin(sp.Provider.github),
                            icon: const Icon(CustomIcon.mark_github),
                            label: const Text("Github"),
                          ),
                        ),
                        const SizedBox.square(dimension: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            style:
                                socialLoginButtonStyle(const Color(0xFFDB4437)),
                            onPressed: () =>
                                _cubit.providerLogin(sp.Provider.google),
                            icon: const Icon(CustomIcon.google),
                            label: const Text("Google"),
                          ),
                        ),
                        const SizedBox.square(dimension: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            style:
                                socialLoginButtonStyle(const Color(0xFF5865F2)),
                            onPressed: () =>
                                _cubit.providerLogin(sp.Provider.discord),
                            icon: const Icon(CustomIcon.discord),
                            label: const Text("Discord"),
                          ),
                        )
                      ],
                    ),
                    const SizedBox.square(dimension: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinkButton(
                          onPressed: () => context.goNamed(AppRouter.signup),
                          text: "Signup",
                        ),
                        SizedBox.fromSize(size: const Size(24, 16)),
                        LinkButton(
                          onPressed: () =>
                              launch("${Uri.base.origin}/policy.html"),
                          text: "Privacy policy",
                        ),
                        SizedBox.fromSize(size: const Size(24, 16)),
                        LinkButton(
                          onPressed: () =>
                              context.goNamed(AppRouter.passwordRecovery),
                          text: "Forgot password",
                        )
                      ],
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
