import 'package:proxy_api_gui/repository/auth_repository.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AuthMiddleWare extends QMiddleware {
  final AuthRepository _repository;
  AuthMiddleWare(this._repository);
  @override
  Future<String?> redirectGuard(String path) async {
    return await _repository.currentUser() == null ? "/login" : null;
  }
}

class LoggedMiddleWare extends QMiddleware {
  final AuthRepository _repository;
  LoggedMiddleWare(this._repository);
  @override
  Future<String?> redirectGuard(String path) async {
    return await _repository.currentUser() != null ? "/" : null;
  }
}