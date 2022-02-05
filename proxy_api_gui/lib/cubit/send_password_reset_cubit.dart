import 'package:bloc/bloc.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';

part 'send_password_reset_state.dart';

class SendPasswordResetCubit extends Cubit<SendPasswordResetState> {
  final AuthRepository _repository;
  SendPasswordResetCubit(this._repository)
      : super(const SendPasswordResetInitial());

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      emit(const SendPasswordResetLoading());
      final result = await _repository.sendPasswordResetEmail(email);
      if (result.error != null) {
        throw Exception(result.error?.message);
      }
      emit(const SendPasswordResetSuccess());
    } catch (e) {
      emit(SendPasswordResetFail(e.toString()));
    }
  }
}
