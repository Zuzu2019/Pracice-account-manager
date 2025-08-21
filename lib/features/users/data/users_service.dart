import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:practice_acount_manager/features/users/presentation/models/password.dart';

import 'package:practice_acount_manager/features/users/presentation/models/users.dart';

final String apiService = dotenv.env['API_SERVICE'] ?? '';

class UsersService {
  Future<List<User>> getUsers(String? token) async {
    final response = await http.get(
      Uri.parse('$apiService/users'),
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

  Future<User> saveUser(User user, String? token) async {
    final response = await http.post(
      Uri.parse('$apiService/register'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return user;
    } else {
      throw Exception('Error al actualizar usuario');
    }
  }

  Future<User> updateUser(int id, User updateUser, String? token) async {
    final url = '$apiService/user/$id';

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateUser.toJson()),
    );

    if (response.statusCode == 200) {
      return updateUser;
    } else {
      throw Exception('Error al actualizar usuario');
    }
  }

  Future<http.Response> deleteUser(int id, String? token) async {
    final response = await http.delete(
      Uri.parse('$apiService/user/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response;
  }

  Future<http.Response> updateUserPassword(
    int id,
    PasswordChange passwords,
    String? token,
  ) async {
    final url = '$apiService/user/pass/$id';

    // final contras = {
    //   "password": "stringA1234*",
    //   "newPassword": "string1pass!",
    //   "confirmPassword": "string1pass!",
    // };

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(passwords),
    );

    return response;
  }
}
