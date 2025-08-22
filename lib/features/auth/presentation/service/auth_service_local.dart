import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final String apiService = dotenv.env['API_SERVICE'] ?? '';
Future<http.Response> login(
  String login,
  String password,
  String tokenRecaptcha,
) async {
  final response = await http.post(
    Uri.parse('$apiService/login'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Client-Type': 'mobile',
      'X-Recaptcha-Site': tokenRecaptcha,
    },

    body: jsonEncode({'login': login, 'password': password}),
  );

  return response;
}

Future<http.Response> logoutLocal() async {
  final response = await http.post(
    Uri.parse('$apiService/user/logout'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Client-Type': 'mobile',
    },

    //body: jsonEncode({'login': login, 'password': password}),
  );

  return response;
}
