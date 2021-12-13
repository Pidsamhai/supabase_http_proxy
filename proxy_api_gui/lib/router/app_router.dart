import 'package:flutter/material.dart';
import 'package:proxy_api_gui/page/create_template.dart';
import 'package:proxy_api_gui/page/edit_template.dart';
import 'package:proxy_api_gui/page/login.dart';
import 'package:proxy_api_gui/page/main.dart';
import 'package:proxy_api_gui/router/auth_middleware.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static const login = "login";
  static const main = "main";
  static const createTemplate = "create";
  static const editTemplate = "edit";
  List<QRoute> routes(BuildContext context) {
    return [
      QRoute(
        name: login,
        path: "/login",
        builder: () => LoginPage(),
        middleware: [
          LoggedMiddleWare(context.read()),
        ],
        pageType: const QFadePage(),
      ),
      QRoute(
        name: main,
        path: "/",
        builder: () => const MainPage(),
        middleware: [
          AuthMiddleWare(context.read()),
        ],
        pageType: const QFadePage(),
      ),
      QRoute(
        name: createTemplate,
        path: "/create",
        builder: () => const CreateTemplatePage(),
        middleware: [
          AuthMiddleWare(context.read())
        ],
        pageType: const QMaterialPage(),
      ),
      QRoute(
        name: editTemplate,
        path: "/edit/:id",
        builder: () => EditTemplatePage(QR.params["id"].toString()),
        middleware: [
          AuthMiddleWare(context.read()),
        ],
        pageType: const QFadePage(),
      ),
    ];
  }
}
