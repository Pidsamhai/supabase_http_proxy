part of 'update_password_cubit.dart';

abstract class UpdatePasswordState {
  const UpdatePasswordState();
}

class UpdatePasswordInitial extends UpdatePasswordState {
  const UpdatePasswordInitial();
}

class UpdatePasswordLoading extends UpdatePasswordState {
  const UpdatePasswordLoading();
}

class UpdatePasswordSuccess extends UpdatePasswordState {
  const UpdatePasswordSuccess();
}

class UpdatePasswordFail extends UpdatePasswordState {
  final String msg;
  UpdatePasswordFail(this.msg);
}
