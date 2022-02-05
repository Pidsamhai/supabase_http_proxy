import 'package:bloc/bloc.dart';
import 'package:proxy_api_gui/cubit/basic_state.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';

class SendPasswordResetCubit extends Cubit<BasicState> {
  final AuthRepository _repository;
  SendPasswordResetCubit(this._repository) : super(const InitailState());

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      emit(const LoadingState());
      final result = await _repository.sendPasswordResetEmail(email);
      if (result.error != null) {
        throw Exception(result.error?.message);
      }
      emit(const SuccessState());
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }
}
