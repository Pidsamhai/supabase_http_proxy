import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:proxy_api_gui/cubit/login_cubit.dart';
import 'package:proxy_api_gui/repository/api_template_repository.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';
import 'package:proxy_api_gui/repository/playground_repository.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:proxy_api_gui/theme/theme.dart';

Future<FirebaseAuth> provideFirebaseAuth() async {
  final auth = FirebaseAuth.instance;
  await auth.setPersistence(Persistence.SESSION);
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

Future<void> initAppCheck() async {
  if (!kDebugMode) {
    await FirebaseAppCheck.instance.activate(
      webRecaptchaSiteKey: "6LefPr4dAAAAAF0d-FFP57NQTFXpXNIRuWP-mwds",
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final auth = await provideFirebaseAuth();
  final database = await provideFirebaseDatabase();
  await initAppCheck();

  runApp(
    MultiProvider(
      child: const MyApp(),
      providers: [
        RepositoryProvider(create: (context) => AuthRepository(auth)),
        RepositoryProvider(
            create: (context) => ApiTemplateRepository(database)),
        Provider<LoginCubit>(create: (context) => LoginCubit(context.read())),
        RepositoryProvider(create: (context) => PlayGroundRepository())
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = AppRouter.routes(context);
    return MaterialApp.router(
      routeInformationParser: routes.routeInformationParser,
      routerDelegate: routes.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: 'Proxy Api',
      theme: ThemeData.from(colorScheme: const ColorScheme.light()).copyWith(
        elevatedButtonTheme:
            ElevatedButtonThemeData(style: elevatedButtonStyle),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 0,
          highlightElevation: 4,
          hoverElevation: 2,
          extendedTextStyle: TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        dialogTheme: dialogTheme,
      ),
    );
  }
}
