import 'package:bloc/bloc.dart';
import 'package:proxy_api_gui/cubit/basic_state.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginCubit extends Cubit<BasicState> {
  final AuthRepository _repository;
  LoginCubit(this._repository) : super(const InitailState());

  Future login(String email, String password) async {
    try {
      emit(const LoadingState());
      final result = await _repository.login(
        email: email,
        password: password,
      );
      if (result.error != null) {
        throw Exception(result.error?.message);
      }
      emit(const SuccessState());
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }

  Future magicLinkSingIn(Uri uri) async {
    try {
      emit(const LoadingState());
      final result = await _repository.magicLinkSignIn(uri);
      if (result.error != null) {
        throw Exception(result.error?.message);
      }
      emit(const SuccessState());
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }

  Future providerLogin(Provider provider) async {
    try {
      emit(const LoadingState());
      final result = await _repository.providerLogin(provider);
      if (!result) {
        throw Exception("Login Fail");
      }
      emit(const SuccessState());
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }
}
