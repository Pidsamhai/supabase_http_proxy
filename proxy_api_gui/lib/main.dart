import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:proxy_api_gui/cubit/login_cubit.dart';
import 'package:proxy_api_gui/cubit/signup_cubit.dart';
import 'package:proxy_api_gui/repository/api_template_repository.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';
import 'package:proxy_api_gui/repository/playground_repository.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:proxy_api_gui/theme/theme.dart';
import 'package:proxy_api_gui/utils/secure_local_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await sp.Supabase.initialize(
    url: dotenv.get("SUPABASE_API_URL"),
    anonKey: dotenv.get("SUPABASE_KEY"),
    debug: kDebugMode,
    localStorage: SecureLocalStorage(),
  );

  final client = sp.Supabase.instance.client;

  runApp(
    MultiProvider(
      child: const MyApp(),
      providers: [
        RepositoryProvider(create: (context) => AuthRepository(client.auth)),
        RepositoryProvider(create: (context) => ApiTemplateRepository(client)),
        Provider<LoginCubit>(create: (context) => LoginCubit(context.read())),
        Provider<SignUpCubit>(create: (context) => SignUpCubit(context.read())),
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
