part of 'send_password_reset_cubit.dart';

abstract class SendPasswordResetState {
  const SendPasswordResetState();
}

class SendPasswordResetInitial extends SendPasswordResetState {
  const SendPasswordResetInitial();
}

class SendPasswordResetLoading extends SendPasswordResetState {
  const SendPasswordResetLoading();
}

class SendPasswordResetSuccess extends SendPasswordResetState {
  const SendPasswordResetSuccess();
}

class SendPasswordResetFail extends SendPasswordResetState {
  final String msg;
  SendPasswordResetFail(this.msg);
}
