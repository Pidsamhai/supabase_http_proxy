import 'package:proxy_api_gui/model/email_metadata.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final GoTrueClient _auth;
  final String? _redirectUrl;
  AuthRepository(this._auth, this._redirectUrl);

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
        redirectTo: _redirectUrl,
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
    return _auth.signInWithProvider(
      provider,
      options: AuthOptions(
        redirectTo: _redirectUrl,
      ),
    );
  }

  Future<bool> deleteAccount() async {
    try {
      final baseUrl = dotenv.env["BASE_API_URL"]!;
      final userId = currentUser()!.id;
      final response = await http.delete(Uri.parse("$baseUrl/user/$userId"));
      await _auth.signOut();
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateEmailMetadata(Email email) async {
    await _auth.update(
      UserAttributes(
        data: email,
      ),
    );
    await _auth.refreshSession();
  }
}
