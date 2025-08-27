import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:practice_acount_manager/riverpod/auth_provider.dart';

final String apiService = dotenv.env['API_SERVICE'] ?? '';

final dominiosProvider = FutureProvider<List>((ref) async {
  final token = ref.read(authProvider).accessToken;
  final tokenRefresh = ref.read(authProvider).refreshToken;
  final response = await http.get(
    Uri.parse('$apiService/transports/1/40'),
    headers: {
      'Authorization': 'Bearer $token',
      if (tokenRefresh != null) 'X-Refresh-Token': tokenRefresh,
      'X-Client-Type': 'mobile',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final List<dynamic> jsonList = jsonResponse["Transports"];
    return jsonList;
  } else {
    throw Exception('Error al obtener los dominios');
  }
});
