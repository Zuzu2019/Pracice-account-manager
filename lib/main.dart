import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:oidc_default_store/oidc_default_store.dart';

import 'package:practice_acount_manager/features/widgets/generals/home.dart';
import 'package:practice_acount_manager/riverpod/statenotifier.dart';
import 'package:practice_acount_manager/features/auth/presentation/pages/select_login_page.dart';
import 'package:practice_acount_manager/features/auth/presentation/service/auth_service.dart';
import 'package:practice_acount_manager/features/core/navigation.dart';
import 'package:practice_acount_manager/features/users/presentation/pages/users_page.dart';
import 'package:practice_acount_manager/features/aliases/presentation/pages/alias_page.dart';
import 'package:practice_acount_manager/features/auth/presentation/pages/login_page_local.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';

late final AuthService authService;

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    final siteKey = dotenv.env['SITE_KEY_RECAPTCHA'];
    if (siteKey == null || siteKey.isEmpty) {
    } else {
      bool ready = await GRecaptchaV3.ready(siteKey, showBadge: true);
      print("🔹 ¿reCAPTCHA listo? $ready");
    }
  } else {
    print("🔹 Plataforma no web, saltando inicialización de reCAPTCHA");
  }

  await OidcDefaultStore().init();
  authService = AuthService();
  await authService.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      debugShowCheckedModeBanner: false,
      initialRoute: '/select_login',
      routes: {
        '/home': (context) {
          return const HomePage();
        },
        '/users': (context) {
          return const UsersPage();
        },
        '/alias': (context) {
          return const AliasPage();
        },
        '/login': (context) {
          return const LoginPage();
        },
        '/select_login': (context) {
          return const SelectLoginPage();
        },
      },
    );
  }
}
