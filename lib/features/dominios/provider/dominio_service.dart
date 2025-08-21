import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:practice_acount_manager/riverpod/auth_provider.dart';

final String apiService = dotenv.env['API_SERVICE'] ?? '';

// Provider que obtiene la lista de dominios
final dominiosProvider = FutureProvider<List>((ref) async {
  // Obtén el token desde otro provider si tienes autenticación
  final token = ref.read(authProvider).accessToken; // ejemplo
  final response = await http.get(
    Uri.parse('$apiService/transports'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList;
  } else {
    throw Exception('Error al obtener los dominios');
  }
});
