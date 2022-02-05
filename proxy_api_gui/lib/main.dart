import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:proxy_api_gui/repository/api_template_repository.dart';
import 'package:proxy_api_gui/repository/auth_repository.dart';
import 'package:proxy_api_gui/repository/playground_repository.dart';
import 'package:proxy_api_gui/router/app_router.dart';
import 'package:proxy_api_gui/theme/theme.dart';
import 'package:proxy_api_gui/utils/secure_local_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "env.txt");
  await sp.Supabase.initialize(
    url: dotenv.get("SUPABASE_API_URL"),
    anonKey: dotenv.get("SUPABASE_KEY"),
    debug: kDebugMode,
    localStorage: SecureLocalStorage(),
  );

  final client = sp.Supabase.instance.client;

  /**
   * Check user account has deleted
   * then signout
   */
  final result = await client.auth.refreshSession();

  if (result.error != null) {
    await client.auth.signOut();
  }

  runApp(
    MultiProvider(
      child: const MyApp(),
      providers: [
        RepositoryProvider(
            create: (context) => AuthRepository(
                  client.auth,
                  dotenv.get("AUTH_REDIRECT_URL"),
                )),
        RepositoryProvider(create: (context) => ApiTemplateRepository(client)),
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
      theme: appThemeData(context),
    );
  }
}
