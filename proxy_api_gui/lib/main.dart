import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proxy_api_gui/cubit/login_cubit.dart';
import 'package:proxy_api_gui/repository/login_repository.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
  await auth.setPersistence(Persistence.LOCAL);
  QR.setUrlStrategy();

  runApp(
    MultiProvider(
      child: const MyApp(),
      providers: [
        Provider<LoginRepository>(create: (context) => LoginRepository(auth)),
        Provider<LoginCubit>(create: (context) => LoginCubit(auth)),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(AppRouter().routes, initPath: "/"),
      debugShowCheckedModeBanner: false,
      title: 'Proxy Api',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
