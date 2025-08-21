import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:practice_acount_manager/l10n/app_localizations.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';
import 'package:practice_acount_manager/features/widgets/generals/home.dart';
import 'package:practice_acount_manager/features/auth/presentation/service/auth_service_local.dart';

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

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  /// Genera token reCAPTCHA v3
  Future<String> getRecaptchaToken() async {
    final Completer<String> tokenCompleter = Completer<String>();
    final String siteKey = dotenv.env['SITE_KEY_RECAPTCHA'] ?? '';

    final String html =
        """
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>reCAPTCHA v3</title>
      <script src="https://www.google.com/recaptcha/api.js?render=$siteKey"></script>
      <script>
        // Captura console.log para debug en Flutter
        const originalLog = console.log;
        console.log = function(msg) {
          ConsoleLog.postMessage(msg);
          originalLog(msg);
        };

        grecaptcha.ready(function() {
          grecaptcha.execute('$siteKey', {action: 'login'}).then(function(token) {
            console.log('Token generado: ' + token);
            Recaptcha.postMessage(token);
          });
        });
      </script>
    </head>
    <body></body>
    </html>
    """;

    // Canal para recibir el token
    _controller.addJavaScriptChannel(
      'Recaptcha',
      onMessageReceived: (message) {
        if (!tokenCompleter.isCompleted) {
          tokenCompleter.complete(message.message);
        }
      },
    );

    _controller.addJavaScriptChannel(
      'ConsoleLog',
      onMessageReceived: (message) {
        print('JS log: ${message.message}');
      },
    );

    _controller.loadHtmlString(html);
    return tokenCompleter.future;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final token = await getRecaptchaToken();
      print("Token recibido en Flutter: $token");

      final authNotifier = ref.read(authProvider.notifier);

      final resp = await login(
        _emailCtrl.text.trim(),
        _passCtrl.text.trim(),
        token,
      );

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;

        authNotifier.setTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${resp.statusCode}')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Form(
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
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 61, 130, 240),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(loc.sign_in, style: const TextStyle(fontSize: 16)),
            ),
          ),
          SizedBox(
            height: 0,
            width: 0,
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}
