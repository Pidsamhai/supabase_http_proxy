import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  AuthRepository(this._auth);

  Future<UserCredential> login(
          {required String email, required String password}) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  User? currentUser() => _auth.currentUser;

  bool get isLogged => currentUser() != null;

  Future<void> signOut() async => _auth.signOut();
}
