import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gcaptcha_v3/recaptca_config.dart';
import 'package:flutter_gcaptcha_v3/web_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/auth/presentation/service/auth_service.dart';
import 'package:practice_acount_manager/features/core/navigation.dart';
import 'package:practice_acount_manager/features/users/presentation/pages/users_page.dart';
import 'package:practice_acount_manager/features/aliases/presentation/pages/alias_page.dart';
import 'package:practice_acount_manager/features/auth/presentation/pages/login_page_local.dart';
import 'package:practice_acount_manager/features/auth/presentation/service/auth_service.dart';
import 'package:practice_acount_manager/features/users/presentation/pages/users_page.dart';
import 'package:practice_acount_manager/features/widgets/generals/drawer.dart';
import 'package:practice_acount_manager/features/widgets/generals/footer.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:oidc_default_store/oidc_default_store.dart';
import 'package:practice_acount_manager/riverpod/statenotifier.dart';

late final AuthService authService;

Future<void> main() async {
  print("🔹 Cargando archivo .env...");
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  print("🔹 WidgetsBinding inicializado");

  if (kIsWeb) {
    final siteKey = dotenv.env['SITE_KEY_RECAPTCHA'];
    if (siteKey == null || siteKey.isEmpty) {
      print("❌ Error: SITE_KEY_RECAPTCHA no está definido en .env");
    } else {
      print("🔹 Inicializando reCAPTCHA v3 con siteKey: $siteKey");
      bool ready = await GRecaptchaV3.ready(siteKey, showBadge: true);
      print("🔹 ¿reCAPTCHA listo? $ready");
    }
  } else {
    print("🔹 Plataforma no web, saltando inicialización de reCAPTCHA");
  }

  print("🔹 Inicializando OidcDefaultStore...");
  await OidcDefaultStore().init();
  print("🔹 OidcDefaultStore inicializado");

  authService = AuthService();
  print("🔹 Inicializando AuthService...");
  await authService.initialize();
  print("🔹 AuthService inicializado");

  print("🔹 Ejecutando runApp...");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    print("🔹 Construyendo MyApp con locale: $locale");

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
          print("🔹 Ruta: /home");
          return const HomePage();
        },
        '/users': (context) {
          print("🔹 Ruta: /users");
          return const UsersPage();
        },
        '/alias': (context) {
          print("🔹 Ruta: /alias");
          return const AliasPage();
        },
        '/login': (context) {
          print("🔹 Ruta: /login");
          return const LoginPage();
        },
        '/select_login': (context) {
          print("🔹 Ruta: /select_login");
          return const SelectLoginPage();
        },
      },
    );
  }
}

// Página Home con Drawer y Footer del primer archivo
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.home,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 23,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 54, 84, 255),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5),
            top: Radius.circular(5),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(child: Center(child: Text(''))),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

// Página SelectLoginPage del segundo archivo
class SelectLoginPage extends StatefulWidget {
  const SelectLoginPage({super.key});

  @override
  State<SelectLoginPage> createState() => _SelectLoginPageState();
}

class _SelectLoginPageState extends State<SelectLoginPage> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    print('🔍 Verificando autenticación...');
    final isAuth = await authService.isAuthenticated();
    print('✅ ¿Está autenticado?: $isAuth');

    if (isAuth) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _handleZitadelLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await authService.login();
      print('✅ Resultado de login Zitadel: $success');

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Autenticación exitosa!')),
        );
        await Future.delayed(const Duration(seconds: 1));
        _navigateToHome();
      } else if (mounted) {
        setState(() => _errorMessage = 'No se pudo completar el login');
      }
    } catch (e) {
      debugPrint("❌ Error durante login con Zitadel: $e");
      if (mounted) {
        setState(() => _errorMessage = 'Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _goToLocalLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/LoginImage.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, size: 130, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: _goToLocalLogin,
                    icon: SvgPicture.asset(
                      'assets/svg/hot-icon.svg',
                      width: 28,
                      height: 28,
                    ),
                    label: const Text('Iniciar sesión local'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 17),
                      minimumSize: const Size(250, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _handleZitadelLogin,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : SvgPicture.asset(
                            'assets/svg/zitadel.svg',
                            width: 28,
                            height: 28,
                          ),
                    label: Text(
                      _isLoading
                          ? 'Conectando...'
                          : 'Iniciar sesión con Zitadel',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLoading ? Colors.grey : Colors.white,
                      textStyle: const TextStyle(fontSize: 17),
                      minimumSize: const Size(250, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
