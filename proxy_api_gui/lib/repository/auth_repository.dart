import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  AuthRepository(this._auth);

  Future<UserCredential> login({required String email, required String password}) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<User?> currentUser() async {
    User? user = _auth.currentUser ?? await _auth.authStateChanges().first;
    return user;
  }

  Future<bool> isLogged() async => await currentUser() != null;

  Future<void> signOut() async => _auth.signOut();
}
