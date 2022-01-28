import 'package:bloc/bloc.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';

part 'update_password_state.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  final AuthRepository _repository;
  UpdatePasswordCubit(this._repository) : super(const UpdatePasswordInitial());

  Future<void> updatePassword(String jwt, String password) async {
    try {
      emit(const UpdatePasswordLoading());
      await _repository.updatePassword(jwt: jwt, newPassword: password);
      emit(const UpdatePasswordSuccess());
    } catch (e) {
      emit(UpdatePasswordFail(e.toString()));
    }
  }
}
