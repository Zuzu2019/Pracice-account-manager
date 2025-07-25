import 'package:flutter/material.dart';

class AliasPage extends StatelessWidget {
  const AliasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Aliases')),
      body: const Center(
        child: Text('Listado de Aliases', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
