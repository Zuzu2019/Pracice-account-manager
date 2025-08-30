import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:practice_acount_manager/features/widgets/generals/drawer.dart';
import 'package:practice_acount_manager/features/widgets/generals/footer.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          loc.home,
          style: TextStyle(
            color: Color.fromARGB(255, 253, 253, 253),
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
      ),
      drawer: const AppDrawer(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: UserInfoWidget(),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({Key? key}) : super(key: key);

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  Map<String, dynamic>? userInfo;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_info');
    if (userJson != null) {
      setState(() {
        userInfo = jsonDecode(userJson);
        loading = false;
      });
    } else {
      setState(() {
        userInfo = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userInfo == null) {
      return const Center(child: Text('No hay información del usuario.'));
    }

    return ListView(
      children: [
        Text(
          'ID (sub): ${userInfo!['sub'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Nombre completo: ${userInfo!['name'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Nombre: ${userInfo!['given_name'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Apellido: ${userInfo!['family_name'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Apodo: ${userInfo!['nickname'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Género: ${userInfo!['gender'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Idioma: ${userInfo!['locale'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Usuario preferido: ${userInfo!['preferred_username'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Correo: ${userInfo!['email'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Correo verificado: ${userInfo!['email_verified'] == true ? "Sí" : "No"}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
