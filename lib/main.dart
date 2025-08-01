import 'package:flutter/material.dart';
import 'package:practice_acount_manager/features/aliases/presentation/pages/alias_page.dart';
import 'package:practice_acount_manager/features/auth/presentation/pages/login_page_local.dart';
import 'package:practice_acount_manager/features/auth/presentation/pages/select_login_page.dart';
import 'package:practice_acount_manager/features/users/presentation/pages/users_page.dart';
import 'package:practice_acount_manager/features/widgets/generals/drawer.dart';
import 'package:practice_acount_manager/features/widgets/generals/footer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/select_login', // Ruta inicial
      routes: {
        '/': (context) => const HomePage(),
        '/users': (context) => const UsersPage(),
        '/alias': (context) => const AliasPage(),
        '/login': (context) => const LoginPage(),
        '/select_login': (context) => const SelectLoginPage(),
        // Agrega más rutas según necesites
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            //SearchBarExample(),
            SizedBox(height: 10),
            Expanded(child: Center(child: Text(''))),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
      // floatingActionButton: const ButtonHome(),
    );
  }
}
