import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:practice_acount_manager/features/users/presentation/models/password.dart';
import 'package:practice_acount_manager/features/users/presentation/models/user_response.dart';

import 'package:practice_acount_manager/features/users/presentation/models/users.dart';

final String apiService = dotenv.env['API_SERVICE'] ?? '';

class UsersService {
  Future<UserResponse> getUsers(
    String? token,
    String? refreshToken, {
    int page = 1,
    int limit = 10,
    String? query = '',
  }) async {
    final response;

    if (query!.isNotEmpty) {
      response = await http.get(
        Uri.parse('$apiService/search/users?query=$query&$page&$limit'),
        headers: {
          'Accept': 'application/json',
          'X-Client-Type': 'mobile',
          if (token != null) 'Authorization': 'Bearer $token',
          if (refreshToken != null) 'X-Refresh-Token': refreshToken,
        },
      );
    } else {
      response = await http.get(
        Uri.parse('$apiService/users/$page/$limit'),
        headers: {
          'Accept': 'application/json',
          'X-Client-Type': 'mobile',
          if (token != null) 'Authorization': 'Bearer $token',
          if (refreshToken != null) 'X-Refresh-Token': refreshToken,
        },
      );
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      return UserResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Error al obtener users');
    }
  }

  Future<http.Response> saveUser(
    User user,
    String? token,
    String? refreshToken,
  ) async {
    final response = await http.post(
      Uri.parse('$apiService/register'),
      headers: {
        'Authorization': 'Bearer $token',
        if (refreshToken != null) 'X-Refresh-Token': refreshToken,
        'X-Client-Type': 'mobile',
        'X-Recaptcha-Site': dotenv.env['SITE_KEY_RECAPTCHA'] ?? '',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    return response;
  }

  Future<http.Response> updateUser(
    int id,
    User updateUser,
    String? token,
    String? refreshToken,
  ) async {
    final url = '$apiService/user/$id';

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        if (refreshToken != null) 'X-Refresh-Token': refreshToken,
        'X-Client-Type': 'mobile',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateUser.toJson()),
    );

    return response;
  }

  Future<http.Response> deleteUser(
    int id,
    String? token,
    String? refreshToken,
  ) async {
    final response = await http.delete(
      Uri.parse('$apiService/user/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        if (refreshToken != null) 'X-Refresh-Token': refreshToken,
        'X-Client-Type': 'mobile',
        'Content-Type': 'application/json',
      },
    );

    return response;
  }

  Future<http.Response> updateUserPassword(
    int id,
    PasswordChange passwords,
    String? token,
    String? refreshToken,
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
        if (refreshToken != null) 'X-Refresh-Token': refreshToken,
        'X-Client-Type': 'mobile',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(passwords),
    );

    return response;
  }

  Future<http.Response> getUser(
    int id,
    String? token,
    String? refreshToken,
  ) async {
    final url = '$apiService/user/$id';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        if (refreshToken != null) 'X-Refresh-Token': refreshToken,
        'X-Client-Type': 'mobile',
        'Content-Type': 'application/json',
      },
    );

    return response;
  }
}
