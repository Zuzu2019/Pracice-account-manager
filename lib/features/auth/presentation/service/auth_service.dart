import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:practice_acount_manager/features/auth/presentation/pages/select_login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class AuthService {
  final String zitadelUrl;
  final String clientId;
  final String callbackScheme;

  String? _codeVerifier;
  final AppLinks _appLinks = AppLinks();

  StreamSubscription? _sub;

  AuthService()
    : zitadelUrl = dotenv.env['ZITADEL_URL'] ?? '',
      clientId = dotenv.env['ZITADEL_CLIENT_ID'] ?? '',
      callbackScheme = dotenv.env['CALLBACK_URL_SCHEME'] ?? '' {
    if (zitadelUrl.isEmpty || clientId.isEmpty || callbackScheme.isEmpty) {
      throw Exception(
        'Variables de entorno faltantes: verifica que ZITADEL_URL, CLIENT_ID y CALLBACK_URL_SCHEME existan en .env',
      );
    }
  }

  Future<void> initialize() async {
    print("AuthService inicializado ✅");
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return token != null && token.isNotEmpty;
  }

  String _generateCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64UrlEncode(
      values,
    ).replaceAll('=', '').replaceAll('+', '-').replaceAll('/', '_');
  }

  String _generateCodeChallenge(String verifier) {
    final challengeBytes = sha256.convert(utf8.encode(verifier)).bytes;
    return base64UrlEncode(
      challengeBytes,
    ).replaceAll('=', '').replaceAll('+', '-').replaceAll('/', '_');
  }

  Future<bool> login() async {
    _codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(_codeVerifier!);

    final authUrl = Uri.parse(
      '$zitadelUrl/oauth/v2/authorize'
      '?client_id=$clientId'
      '&response_type=code'
      '&scope=openid%20profile%20email%20offline_access'
      '&redirect_uri=$callbackScheme://callback'
      '&code_challenge=$codeChallenge'
      '&code_challenge_method=S256',
    );

    if (!await launchUrl(authUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir el navegador');
    }

    final completer = Completer<bool>();
    _sub = _appLinks.uriLinkStream.listen((Uri? uri) async {
      if (uri != null &&
          uri.toString().startsWith('$callbackScheme://callback')) {
        final code = uri.queryParameters['code'];
        if (code != null) {
          try {
            await _exchangeCodeForToken(code);
            completer.complete(true);
          } catch (_) {
            completer.complete(false);
          }
          await _cancelSubscription();
        }
      }
    });

    return completer.future;
  }

  Future<void> _cancelSubscription() async {
    await _sub?.cancel();
    _sub = null;
  }

  Future<void> _exchangeCodeForToken(String code) async {
    final tokenUrl = Uri.parse('$zitadelUrl/oauth/v2/token');

    final response = await http.post(
      tokenUrl,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'code': code,
        'redirect_uri': '$callbackScheme://callback',
        'code_verifier': _codeVerifier!,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveTokens(data);
      await _fetchUserInfo(data['access_token']);
    } else {
      throw Exception('Error al obtener el token: ${response.body}');
    }
  }

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', data['access_token']);
    await prefs.setString('refresh_token', data['refresh_token'] ?? '');
    await prefs.setString('id_token', data['id_token']);
  }

  Future<void> _fetchUserInfo(String accessToken) async {
    final userInfoUrl = Uri.parse('$zitadelUrl/oidc/v1/userinfo');
    final response = await http.get(
      userInfoUrl,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_info', jsonEncode(userData));
      print('Información del usuario: $userData');
    } else {
      throw Exception('Error al obtener información del usuario');
    }
  }
}

// Future<void> logout(BuildContext context, {bool isZitadel = false}) async {
//   final prefs = await SharedPreferences.getInstance();

//   if (isZitadel) {
//     final idToken = prefs.getString('id_token') ?? '';
//     const redirectUri = 'com.practiceacountmanager.app://callback';

//     final logoutUrl = Uri.parse(
//       'https://adminemail-prueba-ftulnf.us1.zitadel.cloud/oidc/v1/end_session'
//       '?id_token_hint=$idToken'
//       '&post_logout_redirect_uri=$redirectUri',
//     );

//     await prefs.clear();

//     if (await canLaunchUrl(logoutUrl)) {
//       await launchUrl(logoutUrl, mode: LaunchMode.externalApplication);
//     } else {
//       debugPrint('No se pudo abrir el navegador para cerrar sesión en Zitadel');
//     }
//   } else {
//     // Logout local
//     final token = prefs.getString('access_token') ?? '';
//     final String apiService = dotenv.env['API_SERVICE'] ?? '';
//     try {
//       await http.post(
//         Uri.parse('$apiService/user/logout'),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'X-Client-Type': 'mobile',
//           if (token.isNotEmpty) 'Authorization': 'Bearer $token',
//         },
//       );
//     } catch (e) {
//       debugPrint('Error logout local: $e');
//     }

//     await prefs.clear();
//   }

//   // Navegar a la pantalla de login eliminando historial
//   if (context.mounted) {
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (_) => const SelectLoginPage()),
//       (route) => false,
//     );
//   }
// }

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final idToken = prefs.getString('id_token') ?? '';
  const redirectUri = 'com.practiceacountmanager.app://callback';

  await prefs.clear();

  final logoutUrl = Uri.parse(
    'https://adminemail-prueba-ftulnf.us1.zitadel.cloud/oidc/v1/end_session'
    '?id_token_hint=$idToken'
    '&post_logout_redirect_uri=$redirectUri',
  );

  if (await canLaunchUrl(logoutUrl)) {
    await launchUrl(logoutUrl, mode: LaunchMode.externalApplication);
  } else {
    debugPrint('No se pudo abrir el navegador para cerrar sesión');
  }

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const SelectLoginPage()),
    (Route<dynamic> route) => false,
  );
}
