import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:qlevar_router/qlevar_router.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    // QR.navigator.popUntilOrPushName(AppRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Main Page",
          style: Theme.of(context).textTheme.headline1,
        ),
        Text(
          FirebaseAuth.instance.currentUser?.uid ?? "Unknown",
        ),
        ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            QR.navigator.replaceAllWithName(AppRouter.main);
          },
          child: const Text("Signout"),
        )
      ],
    );
  }
}
