import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/users/data/users_service.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';

class UserFormNotifier extends StateNotifier<User> {
  final UsersService _service;
  final String? accessToken;
  final String? refreshToken;

  UserFormNotifier(
    User user,
    this._service,
    this.accessToken,
    this.refreshToken,
  ) : super(user);

  // Setters para actualizar campos individuales
  void setLogin(String login) => state = state.copyWith(login: login);
  void setEmail(String email) => state = state.copyWith(email: email);
  void setGrupo(String grupo) => state = state.copyWith(grupo: grupo);
  void setQuota(int quota) => state = state.copyWith(quota: quota);
  void setIdentificacion(String identificacion) =>
      state = state.copyWith(identificacion: identificacion);
  void setDominio(String dominio) =>
      state = state.copyWith(dominio: int.tryParse(dominio) ?? state.dominio);
  void setPassword(String password) =>
      state = state.copyWith(password: password);

  // Cargar usuario desde la API
  Future<void> loadUserForForm(int id) async {
    try {
      final response = await _service.getUser(id, accessToken, refreshToken);
      if (response.statusCode == 200) {
        final user = User.fromJson(jsonDecode(response.body));
        state = user;
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
