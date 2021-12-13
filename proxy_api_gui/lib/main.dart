import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proxy_api_gui/cubit/api_template_cubit.dart';
import 'package:proxy_api_gui/cubit/login_cubit.dart';
import 'package:proxy_api_gui/repository/api_template_repository.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:firebase_database/firebase_database.dart';

Future<FirebaseAuth> provideFirebaseAuth() async {
  final auth = FirebaseAuth.instance;
  await auth.setPersistence(Persistence.LOCAL);
  if (kDebugMode) {
    auth.useAuthEmulator("127.0.0.1", 9099);
  }
  return auth;
}

Future<FirebaseDatabase> provideFirebaseDatabase() async {
  final database = FirebaseDatabase.instance;
  if (kDebugMode) {
    database.useDatabaseEmulator("127.0.0.1", 9000);
  }
  return database;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final auth = await provideFirebaseAuth();
  final database = await provideFirebaseDatabase();
  QR.setUrlStrategy();

  runApp(
    MultiProvider(
      child: const MyApp(),
      providers: [
        Provider<AuthRepository>(create: (context) => AuthRepository(auth)),
        Provider<ApiTemplateRepository>(create: (context) => ApiTemplateRepository(database)),
        Provider<LoginCubit>(create: (context) => LoginCubit(context.read())),
        Provider<ApiTemplateCubit>(create: (context) => ApiTemplateCubit(context.read())),
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
      routerDelegate: QRouterDelegate(
        AppRouter().routes(context),
        initPath: "/",
      ),
      debugShowCheckedModeBanner: false,
      title: 'Proxy Api',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
