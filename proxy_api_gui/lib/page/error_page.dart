import 'package:flutter/material.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.6,
              child: Text(
                "Page not found",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox.square(dimension: 16),
            InkWell(
              onTap: () => context.goNamed(AppRouter.main),
              child: Text(
                "Go Home page",
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    decoration: TextDecoration.underline, color: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }
}
