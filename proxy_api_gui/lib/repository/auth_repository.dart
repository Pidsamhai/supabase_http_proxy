import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
    return _auth.signUp(
      email,
      password,
      options: AuthOptions(
        redirectTo: Uri.base.origin,
      ),
    );
  }

  User? currentUser() => _auth.session()?.user;

  bool get isLogged => currentUser() != null;

  Future<void> signOut() async => _auth.signOut();

  Future<GotrueSessionResponse> magicLinkSignIn(Uri uri) {
    return _auth.getSessionFromUrl(uri);
  }

  Future<bool> providerLogin(Provider provider) {
    return _auth.signInWithProvider(provider);
  }

  Future<bool> deleteAccount() async {
    try {
      final baseUrl = dotenv.env["BASE_API_URL"]!;
      final userId = currentUser()!.id;
      final response = await http.delete(Uri.parse("$baseUrl/user/$userId"));
      await _auth.signOut();
      return [400, 404, 204].contains(response.statusCode);
    } catch (e) {
      print(e);
      return false;
    }
  }
}
