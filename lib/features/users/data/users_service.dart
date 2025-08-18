import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:practice_acount_manager/features/users/presentation/models/users.dart';

Future<List<User>> getUsers(String? token) async {
  final response = await http.get(
    Uri.parse('http://192.168.100.189:7000/users'),
    headers: {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Error al obtener alias');
  }
}

Future<http.Response> saveUser(User user, String? token) async {
  final response = await http.post(
    Uri.parse('http://192.168.100.189:7000/register'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(user.toJson()),
  );

  return response;
}

Future<http.Response> updateUser(int id, User updateUser, String? token) async {
  final url = 'http://192.168.100.189:7000/user/$id';

  final response = await http.put(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(updateUser.toJson()),
  );

  return response;
}

Future<http.Response> deleteUser(int id, String? token) async {
  final response = await http.delete(
    Uri.parse('http://192.168.100.189:7000/user/$id'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  return response;
}

// Future<http.Response> updateUserPassword(int id, String? token) async {
//   final url = 'http://192.168.100.189:7000/user/pass/$id';

//   final contras = {
//     "password": "usuario1pass!",
//     "newPassword": "string1pass!", // nueva contraseña
//     "confirmPassword": "string1pass!", // confirmación
//   };

//   final response = await http.put(
//     Uri.parse(url),
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode(contras), // <-- aquí ya no usamos .toJson()
//   );

//   return response;
// }

Future<List> getDominios(String? token) async {
  final response = await http.get(
    Uri.parse('http://192.168.100.189:7000/transports'),
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
}
