import 'package:firebase_auth/firebase_auth.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AuthMiddleWare extends QMiddleware {
  final _auth = FirebaseAuth.instance;
  @override
  Future<String?> redirectGuard(String path) async {
    return _auth.currentUser == null ? "/login" : null;
  }
}

class LoggedMiddleWare extends QMiddleware {
  final _auth = FirebaseAuth.instance;
  @override
  Future<String?> redirectGuard(String path) async {
    return _auth.currentUser != null ? "/" : null;
  }
}
  // static Future<FirebaseUser> getFirebaseUser() async {
  //   FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
  //   if (firebaseUser == null) {
  //     firebaseUser = await FirebaseAuth.instance.onAuthStateChanged.first;
  //   }
  //   return firebaseUser;
  // }