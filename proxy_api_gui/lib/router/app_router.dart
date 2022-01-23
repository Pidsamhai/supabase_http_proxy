import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proxy_api_gui/page/create_template.dart';
import 'package:proxy_api_gui/page/edit_template.dart';
import 'package:proxy_api_gui/page/error_page.dart';
import 'package:proxy_api_gui/page/login.dart';
import 'package:proxy_api_gui/page/main.dart';
import 'package:proxy_api_gui/page/playground.dart';
import 'package:proxy_api_gui/page/signup.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';
import 'package:provider/provider.dart';
import 'package:proxy_api_gui/router/custom_page_transittion.dart';
import 'package:proxy_api_gui/utils/extensions.dart';

class AppRouter {
  static const login = "login";
  static const signup = "signup";
  static const main = "main";
  static const createTemplate = "create";
  static String editTemplate(String id) => "/edit/$id";
  static const playground = "playground";
  static GoRouter routes(BuildContext context) {
    return GoRouter(
      urlPathStrategy: UrlPathStrategy.path,
      errorPageBuilder: (context, state) => fadePage(
        child: const ErrorPage(),
        state: state,
      ),
      routes: [
        GoRoute(
          name: main,
          path: "/",
          pageBuilder: (context, state) => fadePage(
            child: const MainPage(),
            state: state,
          ),
          redirect: (state) => _authMiddleWare(context.read()),
        ),
        GoRoute(
          name: signup,
          path: "/signup",
          pageBuilder: (context, state) => fadePage(
            child: const SignupPage(),
            state: state,
          ),
          redirect: (state) => _loggedInMiddleWare(context.read()),
        ),
        GoRoute(
          name: login,
          path: "/login",
          pageBuilder: (context, state) => fadePage(
            child: LoginPage(magicLink: state.magicLink()),
            state: state,
          ),
          redirect: (state) => _loggedInMiddleWare(context.read()),
        ),
        GoRoute(
          name: createTemplate,
          path: "/create",
          pageBuilder: (context, state) => materialPage(
            child: const CreateTemplatePage(),
            state: state,
          ),
          redirect: (state) => _authMiddleWare(context.read()),
        ),
        GoRoute(
          path: "/edit/:id",
          pageBuilder: (context, state) => materialPage(
            child: EditTemplatePage(state.params["id"]!),
            state: state,
          ),
          redirect: (state) => _authMiddleWare(context.read()),
        ),
        GoRoute(
          name: playground,
          path: "/playground",
          pageBuilder: (context, state) => materialPage(
            child: const PlaygroundPage(),
            state: state,
          ),
          redirect: (state) => _authMiddleWare(context.read()),
        ),
      ],
    );
  }

  static String? _authMiddleWare(AuthRepository repository) {
    final uri = Uri.parse(Uri.base.toString().replaceFirst("/#", "?"));
    return repository.currentUser() == null ? ("/login?" + uri.query) : null;
  }

  static String? _loggedInMiddleWare(AuthRepository repository) {
    return repository.currentUser() != null ? "/" : null;
  }
}
