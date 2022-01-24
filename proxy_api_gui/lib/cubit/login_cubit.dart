import 'package:bloc/bloc.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';
import 'package:proxy_api_gui/cubit/login_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;
  LoginCubit(this._repository) : super(const LoginInitial());

  Future login(String email, String password) async {
    try {
      emit(const LoginLoading());
      final result = await _repository.login(
        email: email,
        password: password,
      );
      if (result.error != null) {
        throw Exception(result.error?.message);
      }
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future magicLinkSingIn(Uri uri) async {
    try {
      emit(const LoginLoading());
      final result = await _repository.magicLinkSignIn(uri);
      if (result.error != null) {
        throw Exception(result.error?.message);
      }
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future providerLogin(Provider provider) async {
    try {
      emit(const LoginLoading());
      final result = await _repository.providerLogin(provider);
      if (!result) {
        throw Exception("Login Fail");
      }
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
