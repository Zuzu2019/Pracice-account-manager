import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Usuarios')),
      body: const Center(
        child: Text('Listado de Usuarios', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
