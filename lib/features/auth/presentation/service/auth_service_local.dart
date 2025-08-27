import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginService {
  /// Realiza login local con email/usuario y password, enviando token de reCAPTCHA
  Future<http.Response?> login({
    required String login,
    required String password,
    required String tokenRecaptcha,
  }) async {
    final String baseUrl = dotenv.env['URL_BASE'] ?? '';
    final String port = dotenv.env['URL_PORT'] ?? '';
    final String url = (port.isNotEmpty)
        ? '$baseUrl/login'
        : '$baseUrl/login';

    print("🔹 URL de login: $url");

    if (baseUrl.isEmpty) {
      print("❌ LoginService: URL_BASE no configurada en .env");
      return null;
    }

    // Mostrar token recibido (truncado para consola)
    final tokenPreview = tokenRecaptcha.length > 10
        ? tokenRecaptcha.substring(0, 10) + '...'
        : tokenRecaptcha;
    print("🔹 Token reCAPTCHA a enviar: $tokenPreview");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-Client-Type': 'mobile',
          'X-Recaptcha-Site': tokenRecaptcha,
        },
        body: jsonEncode({'login': login, 'password': password}),
      );

      print("🔹 Status code: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");
      return response;
    } catch (e) {
      print("❌ LoginService: Error en petición login: $e");
      return null;
    }
  }
}
