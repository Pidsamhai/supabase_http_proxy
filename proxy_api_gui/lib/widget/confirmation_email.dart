import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proxy_api_gui/router/app_router.dart';

class ConfirmationEmailWidget extends StatelessWidget {
  const ConfirmationEmailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Confirmation email sent",
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox.square(dimension: 16),
          Text(
            "Please check your email end confirm email addredd.",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox.square(dimension: 16),
          ElevatedButton(
            onPressed: () => context.goNamed(AppRouter.login),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Back to login"),
            ),
          )
        ],
      ),
    );
  }
}
