import 'package:bloc/bloc.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';
import 'package:proxy_api_gui/cubit/login_state.dart';

class SignUpCubit extends Cubit<LoginState> {
  final AuthRepository _repository;
  SignUpCubit(this._repository) : super(const LoginInitial());

  Future signup(String email, String password) async {
    try {
      emit(const LoginLoading());
      final session = await _repository.signUp(
        email: email,
        password: password,
      );
      print(session);
      print(session.user);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
