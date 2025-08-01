import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:practice_acount_manager/features/auth/presentation/pages/login_page_local.dart';

class SelectLoginPage extends StatelessWidget {
  const SelectLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/LoginImage.png', fit: BoxFit.cover),

          // Capa de oscurecimiento
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

                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const LoginPage(),
                      );
                    },
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

                  // Botón con SVG
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/svg/zitadel.svg',
                      width: 28,
                      height: 28,
                    ),
                    label: const Text('Iniciar sesión con Zitadel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
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
