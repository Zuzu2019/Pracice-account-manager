import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:practice_acount_manager/features/auth/presentation/service/auth_service_local.dart';
import 'package:practice_acount_manager/features/auth/presentation/service/recaptcha_web_view.dart';
import 'package:practice_acount_manager/features/widgets/generals/home.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;

  final LoginService _loginService = LoginService();

  // GlobalKey para acceder al WebView y obtener token
  final GlobalKey<RecaptchaWebViewState> _recaptchaKey = GlobalKey<RecaptchaWebViewState>();
  late final RecaptchaWebView _recaptcha;

  @override
  void initState() {
    super.initState();
    _recaptcha = RecaptchaWebView(
      key: _recaptchaKey,
      action: 'login',
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String token;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🔹 Iniciando login...')),
      );

      if (kIsWeb) {
        print("🔹 Plataforma Web: obteniendo token GRecaptchaV3");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🔹 Obteniendo token reCAPTCHA web...')),
        );

        token = await GRecaptchaV3.execute('login') ?? '';
        if (token.isEmpty) throw Exception("No se pudo obtener token reCAPTCHA web");

      } else {
        print("🔹 Plataforma Móvil: obteniendo token desde WebView");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🔹 Obteniendo token reCAPTCHA móvil...')),
        );

        token = await _recaptchaKey.currentState!.getToken();
        if (token.isEmpty) throw Exception("No se pudo obtener token reCAPTCHA móvil");
      }

      print("🔹 Token obtenido: $token");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🔹 Token reCAPTCHA obtenido')),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🔹 Enviando datos de login...')),
      );

      final resp = await _loginService.login(
        login: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
        tokenRecaptcha: token,
      );

      if (resp != null && resp.statusCode == 200) {
        print("✅ Login exitoso");
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        ref.read(authProvider.notifier).setTokens(
          accessToken: data['access'],
          refreshToken: data['refresh'],
        );
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      } else {
        print("❌ Login fallido: ${resp?.statusCode ?? 'sin respuesta'}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Login fallido: ${resp?.statusCode ?? 'sin respuesta'}')),
        );
      }
    } catch (e) {
      print("❌ Excepción durante login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Login fallido: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: loc.label_login,
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? loc.field_required : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: loc.label_password,
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? loc.field_required : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.login),
                  label: Text(
                    _isLoading ? 'Conectando...' : loc.sign_in,
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 61, 130, 240),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _recaptcha, // WebView oculto para móvil
      ],
    );
  }
}
