import 'package:bloc/bloc.dart';
import 'package:proxy_api_gui/cubit/basic_state.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';

class UpdatePasswordCubit extends Cubit<BasicState> {
  final AuthRepository _repository;
  UpdatePasswordCubit(this._repository) : super(const InitailState());

  Future<void> updatePassword(String jwt, String password) async {
    try {
      emit(const LoadingState());
      await _repository.updatePassword(jwt: jwt, newPassword: password);
      emit(const SuccessState());
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }

  Future<void> updateUserPassword(String password) async {
    try {
      emit(const LoadingState());
      await _repository.updateUserPassword(password);
      emit(const SuccessState());
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }
}
