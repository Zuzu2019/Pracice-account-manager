import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:practice_acount_manager/features/aliases/models/aliases.dart';

Future<List<Aliases>> getAlias(String? token) async {
  final response = await http.get(
    Uri.parse('http://192.168.100.189:7000/aliases'),
    headers: {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Aliases.fromJson(json)).toList();
  } else {
    throw Exception('Error al obtener alias');
  }
}

Future<http.Response> saveAlias(Aliases newAlias, String? token) async {
  final response = await http.post(
    Uri.parse('http://192.168.100.189:7000/alias'),
    headers: {
      'Authorization': 'Bearer $token',
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
) async {
  final url = 'http://192.168.100.189:7000/alias/$id';

  final response = await http.put(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(updateAlias.toJson()),
  );

  return response;
}

Future<http.Response> deleteAlias(int id, String? token) async {
  final response = await http.delete(
    Uri.parse('http://192.168.100.189:7000/alias/$id'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  return response;
}
