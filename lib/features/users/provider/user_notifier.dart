import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/users/data/users_service.dart';
import 'package:practice_acount_manager/features/users/presentation/models/password.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

class UserNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final UsersService _service;
  final Ref _ref;

  String _searchQuery = '';
  List<User> _allUsers = [];

  UserNotifier(this._service, this._ref) : super(AsyncValue.loading()) {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    state = const AsyncValue.loading();

    try {
      final token = _ref.read(authProvider).accessToken;
      final users = await _service.getUsers(token);
      //state = AsyncValue.data(users);
      _allUsers = users;
      _applyFilter();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addUsers(User user) async {
    state = const AsyncValue.loading();

    try {
      final token = _ref.read(authProvider).accessToken;
      await _service.saveUser(user, token);
      await fetchUsers();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateUsers(User user, int id) async {
    try {
      final token = _ref.read(authProvider).accessToken;
      await _service.updateUser(id, user, token);
      await fetchUsers();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      final token = _ref.read(authProvider).accessToken;
      final resp = await _service.deleteUser(id, token);

      if (resp.statusCode == 200) {
        state = state.whenData(
          (users) => users.where((u) => u.id != id).toList(),
        );
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  Future<void> updatePassword(int id, PasswordChange passwords) async {
    try {
      final token = _ref.read(authProvider).accessToken;
      await _service.updateUserPassword(id, passwords, token);
      //await fetchUsers();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
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
}
