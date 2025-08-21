import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> login(
  String login,
  String password,
  String tokenRecaptcha,
) async {
  final response = await http.post(
    Uri.parse('http://192.168.100.189:7000/login'),
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
