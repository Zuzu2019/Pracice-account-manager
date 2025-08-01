import 'package:flutter/material.dart';
import '../widgets/login_form_local.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color de fondo general
      backgroundColor: Colors.white,

      // AppBar con botón de regresar
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 54, 84, 255),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(2),
            top: Radius.circular(0),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Regresar', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),

      // Cuerpo de la página
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.lock, size: 80, color: Colors.blue),
              SizedBox(height: 16),
              Text(
                'Iniciar sesión',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
