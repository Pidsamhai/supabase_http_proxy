import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth;
  LoginCubit(this._auth) : super(const LoginInitial());

  Future login(String email, String password) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(const LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(e.message ?? "Error"));
    }
  }
}
