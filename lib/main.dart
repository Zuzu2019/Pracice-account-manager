import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/aliases/presentation/pages/alias_page.dart';
import 'package:practice_acount_manager/features/auth/presentation/pages/login_page_local.dart';
import 'package:practice_acount_manager/features/auth/presentation/pages/select_login_page.dart';
import 'package:practice_acount_manager/features/users/presentation/pages/users_page.dart';
import 'package:practice_acount_manager/features/widgets/generals/drawer.dart';
import 'package:practice_acount_manager/features/widgets/generals/footer.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';
import 'package:practice_acount_manager/riverpod/statenotifier.dart'; // tu provider de locale

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// MyApp como ConsumerWidget para acceder a Riverpod
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale, // locale global gestionado por Riverpod
      debugShowCheckedModeBanner: false,
<<<<<<< Updated upstream
      initialRoute: '/select_login', // Ruta inicial
=======
      initialRoute: '/login',
>>>>>>> Stashed changes
      routes: {
        '/': (context) => const HomePage(),
        '/users': (context) => const UsersPage(),
        '/alias': (context) => const AliasPage(),
        '/login': (context) => const LoginPage(),
<<<<<<< Updated upstream
        '/select_login': (context) => const SelectLoginPage(),
        // Agrega más rutas según necesites
=======
>>>>>>> Stashed changes
      },
    );
  }
}

// HomePage sin recibir onLocaleChange, el drawer usará Riverpod
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
      drawer: const AppDrawer(), // drawer usa ConsumerWidget para locale
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            //SearchBarExample(),
            SizedBox(height: 10),
            Expanded(child: Center(child: Text(''))),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
