import 'package:bloc/bloc.dart';
import 'package:proxy_api_gui/cubit/basic_state.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';

class SignUpCubit extends Cubit<BasicState> {
  final AuthRepository _repository;
  SignUpCubit(this._repository) : super(const InitailState());

  Future signup(String email, String password) async {
    try {
      emit(const LoadingState());
      await _repository.signUp(
        email: email,
        password: password,
      );
      emit(const SuccessState());
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }
}
