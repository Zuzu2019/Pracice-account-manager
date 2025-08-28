import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/users/data/users_service.dart';
import 'package:practice_acount_manager/features/users/presentation/models/password.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';
import 'package:practice_acount_manager/features/users/provider/user_provider.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

class UserNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final UsersService _service;
  final Ref _ref;

  String _searchQuery = '';
  List<User> _allUsers = [];
  bool _hasMore = true;
  bool _isLoadingMore = false;

  UserNotifier(this._service, this._ref) : super(AsyncValue.loading()) {
    fetchUsers();
  }

  AuthState get _auth => _ref.read(authProvider);
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> fetchUsers() async {
    state = const AsyncValue.loading();

    try {
      final users = await _service.getUsers(
        _auth.accessToken,
        _auth.refreshToken,
      );
      //state = AsyncValue.data(users);
      _allUsers = users.users;
      _applyFilter();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addUsers(User user, tokenR) async {
    state = const AsyncValue.loading();
    try {
      final response = await _service.saveUser(
        user,
        _auth.accessToken,
        _auth.refreshToken,
        tokenR,
      );

      if (response.statusCode == 200) {
        final manager = _ref.read(usersPagingProvider);
        manager.reset();
        await manager.fetchNextPage();
      } else {
        final body = response.body;
        throw Exception('Error ${response.statusCode}: $body');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<bool> updateUsers(User user, int id) async {
    try {
      final response = await _service.updateUser(
        id,
        user,
        _auth.accessToken,
        _auth.refreshToken,
      );

      if (response.statusCode == 200) {
        final manager = _ref.read(usersPagingProvider);
        manager.reset();
        await manager.fetchNextPage();
        return true;
      } else {
        final body = response.body;
        throw Exception('Error ${response.statusCode}: $body');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      final resp = await _service.deleteUser(
        id,
        _auth.accessToken,
        _auth.refreshToken,
      );

      if (resp.statusCode == 200) {
        state = state.whenData(
          (users) => users.where((u) => u.id != id).toList(),
        );
        // return true;
        final manager = _ref.read(usersPagingProvider);
        manager.reset();
        await manager.fetchNextPage();
        return true;
      } else {
        final body = resp.body;
        throw Exception('Error ${resp.statusCode}: $body');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updatePassword(int id, PasswordChange passwords) async {
    try {
      final response = await _service.updateUserPassword(
        id,
        passwords,
        _auth.accessToken,
        _auth.refreshToken,
      );

      if (response.statusCode == 200) {
        final manager = _ref.read(usersPagingProvider);
        manager.reset();
        await manager.fetchNextPage();
        return;
      } else {
        final body = response.body;
        throw Exception('Error ${response.statusCode}: $body');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  void _applyFilter() {
    final filtered = _searchQuery.isEmpty
        ? _allUsers
        : _allUsers.where((u) {
            return u.login.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                u.email.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

    state = AsyncValue.data(filtered);
  }

  Future<void> reload() async {
    state = AsyncValue.loading();
    await fetchUsers();
  }

  Future<User?> fetchUserById(int id) async {
    try {
      final response = await _service.getUser(
        id,
        _auth.accessToken,
        _auth.refreshToken,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Si tu API devuelve un objeto usuario directo
        final user = User.fromJson(data);
        return user;

        // Si tu API devuelve algo como { "user": {...} }
        // final user = User.fromJson(data['user']);
        // return user;
      } else {
        final body = response.body;
        throw Exception('Error ${response.statusCode}: $body');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
