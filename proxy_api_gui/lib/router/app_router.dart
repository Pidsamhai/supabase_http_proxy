import 'package:proxy_api_gui/page/login.dart';
import 'package:proxy_api_gui/page/main.dart';
import 'package:proxy_api_gui/router/auth_middleware.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AppRouter {
  static const login = "login";
  static const main = "main";
  final routes = [
    QRoute(
      name: login,
      path: "/login",
      builder: () => LoginPage(),
      middleware: [
        LoggedMiddleWare(),
      ],
      pageType: const QFadePage(),
    ),
    QRoute(
      name: main,
      path: "/",
      builder: () => const MainPage(),
      middleware: [
        AuthMiddleWare(),
      ],
      pageType: const QFadePage(),
    ),
  ];
}
