import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecaptchaWebView extends StatefulWidget {
  final String action;
  const RecaptchaWebView({super.key, required this.action});

  @override
  RecaptchaWebViewState createState() => RecaptchaWebViewState();
}

class RecaptchaWebViewState extends State<RecaptchaWebView> {
  late final WebViewController _controller;
  final Completer<String> _tokenCompleter = Completer<String>();

  // Método público que devuelve Future<String>
  Future<String> getToken() async {
    print("🔹 getToken() llamado en Flutter...");
    try {
      final token = await _tokenCompleter.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          print("❌ Timeout: no se obtuvo token reCAPTCHA en 15s");
          return '';
        },
      );
      print(
        "🔹 Token recibido en Flutter: ${token.isEmpty ? 'VACÍO' : token.substring(0, 10) + '...'}",
      );
      return token;
    } catch (e) {
      print("❌ Excepción al obtener token: $e");
      return '';
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Recaptcha',
        onMessageReceived: (message) {
          final msg = message.message;

          if (msg.startsWith('LOG:')) {
            // Solo imprimir logs
            print("🌐 Mensaje desde HTML: $msg");
          } else {
            // Completar con token real
            if (!_tokenCompleter.isCompleted) {
              print("🌐 Token recibido desde HTML: $msg");
              _tokenCompleter.complete(msg);
            }
          }
        },
      )
      ..loadFlutterAsset('assets/recaptcha.html');

    print("🔹 WebView inicializado, cargando recaptcha.html...");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0,
      width: 0,
      child: WebViewWidget(controller: _controller),
    );
  }
}
