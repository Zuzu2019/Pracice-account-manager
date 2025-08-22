import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:practice_acount_manager/features/aliases/models/aliases.dart';

final String apiService = dotenv.env['API_SERVICE'] ?? '';

class AliasService {
  Future<List<Aliases>> getAlias(String? token, String? refreshToken) async {
    final response = await http.get(
      Uri.parse('$apiService/aliases/1/10'),
      headers: {
        'Accept': 'application/json',
        'X-Client-Type': 'mobile',
        if (token != null) 'Authorization': 'Bearer $token',
        if (refreshToken != null) 'X-Refresh-Token': refreshToken,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> jsonList = jsonResponse["Alias"];
      return jsonList.map((json) => Aliases.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener alias');
    }
  }

  Future<http.Response> saveAlias(
    Aliases newAlias,
    String? token,
    String? refreshToken,
  ) async {
    final response = await http.post(
      Uri.parse('$apiService/alias'),
      headers: {
        'Authorization': 'Bearer $token',
        if (refreshToken != null) 'X-Refresh-Token': refreshToken,
        'X-Client-Type': 'mobile',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(newAlias.toJson()),
    );

    return response;
  }

  Future<http.Response> updateAlias(
    int id,
    Aliases updateAlias,
    String? token,
    String? refreshToken,
  ) async {
    final url = '$apiService/alias/$id';

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        if (refreshToken != null) 'X-Refresh-Token': refreshToken,
        'X-Client-Type': 'mobile',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateAlias.toJson()),
    );

    return response;
  }

  Future<http.Response> deleteAlias(
    int id,
    String? token,
    String? refreshToken,
  ) async {
    final response = await http.delete(
      Uri.parse('$apiService/alias/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        if (refreshToken != null) 'X-Refresh-Token': refreshToken,
        'Content-Type': 'application/json',
        'X-Client-Type': 'mobile',
      },
    );

    return response;
  }
}
