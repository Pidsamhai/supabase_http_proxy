import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:proxy_api_gui/cubit/send_password_reset_cubit.dart';
import 'package:proxy_api_gui/cubit/update_password_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';
import 'package:proxy_api_gui/router/app_router.dart';

enum RecoveryState { requestPasswordReset, newPassword, expried }

class PasswordResetPage extends StatefulWidget {
  final String? _jwt;
  const PasswordResetPage(this._jwt, {Key? key}) : super(key: key);

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  final _requestPasswordResetKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _emailController = TextEditingController();
  bool get _newPasswordIsValid => _formKey.currentState?.validate() == true;
  bool get _emailiIsValid =>
      _requestPasswordResetKey.currentState?.validate() == true;

  Widget get _content {
    if (widget._jwt == null) {
      return _requestResetpassword();
    }
    if (JwtDecoder.isExpired(widget._jwt!)) {
      return _expriedLink();
    } else {
      return _newPasswordContent(context);
    }
  }

  late UpdatePasswordCubit _cubit;

  _updatePassword() {
    _cubit.updatePassword(
      widget._jwt!,
      _passwordController.text,
    );
  }

  _rebuilder() => setState(() => {});

  @override
  void initState() {
    super.initState();
    _cubit = UpdatePasswordCubit(context.read());
    _passwordController.addListener(_rebuilder);
    _passwordConfirmController.addListener(_rebuilder);
    _emailController.addListener(_rebuilder);
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.removeListener(_rebuilder);
    _passwordConfirmController.removeListener(_rebuilder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: _content,
        ),
      ),
    );
  }

  Widget _newPasswordContent(BuildContext context) {
    return BlocBuilder<UpdatePasswordCubit, UpdatePasswordState>(
      bloc: _cubit,
      builder: (context, state) {
        final bool _isLoading = state is UpdatePasswordLoading;
        if (state is UpdatePasswordSuccess) {
          return _updateSuccess();
        }
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Password recovery",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox.square(dimension: 16),
              TextFormField(
                controller: _passwordController,
                autovalidateMode: AutovalidateMode.always,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                validator: (String? value) {
                  return ((value?.trim().length ?? 0) < 6)
                      ? 'Password must be greater than 6 digit *'
                      : null;
                },
              ),
              const SizedBox.square(dimension: 16),
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                controller: _passwordConfirmController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                ),
                validator: (String? value) {
                  return value != _passwordController.text
                      ? 'Password not match *'
                      : null;
                },
              ),
              const SizedBox.square(dimension: 16),
              SizedBox(
                height: 48,
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: (_newPasswordIsValid || _isLoading)
                      ? _updatePassword
                      : null,
                  child: const Text("Save"),
                ),
              ),
              if (state is UpdatePasswordFail) ...[
                const SizedBox.square(dimension: 8),
                Text(
                  state.msg,
                  style: const TextStyle(color: Colors.red),
                )
              ],
              if (_isLoading) ...[
                const SizedBox.square(dimension: 8),
                const LinearProgressIndicator()
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _expriedLink() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Link has been exriped"),
          const SizedBox.square(dimension: 16),
          _btnBackToLoginPage()
        ],
      ),
    );
  }

  Widget _btnBackToLoginPage() {
    return ElevatedButton(
      onPressed: () => context.goNamed(AppRouter.login),
      child: const Text("Back to login"),
    );
  }

  Widget _updateSuccess() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Password has been updated"),
          const SizedBox.square(dimension: 16),
          _btnBackToLoginPage()
        ],
      ),
    );
  }

  Widget _sendSuccess() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Password reset send to ${_emailController.text}"),
          const SizedBox.square(dimension: 16),
          _btnBackToLoginPage()
        ],
      ),
    );
  }

  Widget _requestResetpassword() {
    SendPasswordResetCubit _cubit = SendPasswordResetCubit(context.read());

    _sendPasswordResetEmail() {
      _cubit.sendPasswordResetEmail(_emailController.text);
    }

    return BlocBuilder<SendPasswordResetCubit, SendPasswordResetState>(
      bloc: _cubit,
      builder: (context, state) {
        bool _isLoading = state is SendPasswordResetLoading;
        if (state is SendPasswordResetSuccess) {
          return _sendSuccess();
        }
        return Form(
          key: _requestPasswordResetKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                controller: _emailController,
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
              SizedBox(
                height: 48,
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: (_emailiIsValid && !_isLoading)
                      ? _sendPasswordResetEmail
                      : null,
                  child: const Text("Send password reset email"),
                ),
              ),
              if (_isLoading) ...[
                const SizedBox.square(dimension: 16),
                const LinearProgressIndicator()
              ],
              if (state is SendPasswordResetFail) ...[
                const SizedBox.square(dimension: 16),
                Text(
                  state.msg,
                  style: const TextStyle(color: Colors.red),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
