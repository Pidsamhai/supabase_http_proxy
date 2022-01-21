import 'package:supabase/supabase.dart';

class AuthRepository {
  final GoTrueClient _auth;
  AuthRepository(this._auth);

  Future<GotrueResponse> login({
    required String email,
    required String password,
  }) =>
      _auth.signIn(email: email, password: password);

  Future<GotrueSessionResponse> signUp({
    required String email,
    required String password,
  }) {
    return _auth.signUp(email, password);
  }

  User? currentUser() => _auth.session()?.user;

  bool get isLogged => currentUser() != null;

  Future<void> signOut() async => _auth.signOut();
}
