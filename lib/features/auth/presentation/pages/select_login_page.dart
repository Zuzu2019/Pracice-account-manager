import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/flutter_svg.dart';

import 'package:practice_acount_manager/features/auth/presentation/pages/login_page_local.dart';
import 'package:practice_acount_manager/main.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

class SelectLoginPage extends ConsumerStatefulWidget {
  const SelectLoginPage({super.key});

  @override
  ConsumerState<SelectLoginPage> createState() => _SelectLoginPageState();
}

class _SelectLoginPageState extends ConsumerState<SelectLoginPage> {
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
      ref.read(authProvider.notifier).loadTokens();
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
                          : 'Iniciar sesión con Zitadelllllll',
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
