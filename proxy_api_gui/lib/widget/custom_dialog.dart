import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class CustomDialog extends QDialog {
  late final bool _barrierDismissible;
  CustomDialog(
      {required Widget Function(void Function<T>([T]) pop) widget,
      Color? barrierColor,
      bool useSafeArea = true,
      bool useRootNavigator = true,
      Duration? transitionDuration,
      Curve? transitionCurve,
      RouteSettings? routeSettings,
      RouteTransitionsBuilder? transitionBuilder,
      bool barrierDismissible = false})
      : super(
          widget: widget,
          barrierColor: barrierColor,
          transitionDuration: transitionDuration,
          transitionCurve: transitionCurve,
          routeSettings: routeSettings,
          transitionBuilder: transitionBuilder,
        ) {
    _barrierDismissible = barrierDismissible;
  }

  @override
  bool get barrierDismissible => _barrierDismissible;
}
