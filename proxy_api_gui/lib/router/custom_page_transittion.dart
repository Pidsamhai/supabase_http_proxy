import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage fadePage({
  required Widget child,
  required GoRouterState state,
  Duration duration = const Duration(milliseconds: 300),
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    transitionDuration: duration,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

MaterialPage materialPage({
  required Widget child,
  required GoRouterState state,
}) {
  return MaterialPage(
    key: state.pageKey,
    restorationId: state.pageKey.value,
    child: child,
  );
}
