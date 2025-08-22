import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/users/data/users_service.dart';
import 'package:practice_acount_manager/features/users/presentation/models/password.dart';
import 'package:practice_acount_manager/features/users/presentation/models/user_response.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

class UserNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final UsersService _service;
  final Ref _ref;

  String _searchQuery = '';
  List<User> _allUsers = [];
  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  UserNotifier(this._service, this._ref) : super(AsyncValue.loading()) {
    fetchUsers();
  }

  AuthState get _auth => _ref.read(authProvider);
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  //  Future<void> fetchUsers({bool loadMore = false}) async {
  //   if (loadMore && state.isLoadingMore) return;

  //   try {
  //     if (!loadMore) {
  //       _currentPage = 1;
  //       state = state.copyWith(
  //         isLoadingMore: false,
  //         hasMore: true,
  //         users: [],
  //       );
  //     } else {
  //       _currentPage++;
  //       state = state.copyWith(isLoadingMore: true);
  //     }

  //     final response = await _service.getUsers(
  //       _auth.accessToken,
  //       _auth.refreshToken,
  //       page: _currentPage,
  //       limit: _limit,
  //     );

  //     final allUsers = [
  //       if (loadMore) ...state.users,
  //       ...response.users,
  //     ];

  //     state = state.copyWith(
  //       users: allUsers,
  //       hasMore: _currentPage < response.totalPages,
  //       isLoadingMore: false,
  //     );
  //   } catch (e) {
  //     state = state.copyWith(isLoadingMore: false);
  //     rethrow;
  //   }
  // }
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

  Future<void> addUsers(User user) async {
    state = const AsyncValue.loading();
    try {
      final response = await _service.saveUser(
        user,
        _auth.accessToken,
        _auth.refreshToken,
      );

      if (response.statusCode == 200) {
        await fetchUsers();
      } else {
        final body = response.body;
        throw Exception('Error ${response.statusCode}: $body');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateUsers(User user, int id) async {
    try {
      final response = await _service.updateUser(
        id,
        user,
        _auth.accessToken,
        _auth.refreshToken,
      );

      if (response.statusCode == 200) {
        await fetchUsers();
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
      final response = await _service.updateUserPassword(
        id,
        passwords,
        _auth.accessToken,
        _auth.refreshToken,
      );

      if (response.statusCode == 200) {
        await fetchUsers();
      } else {
        final body = response.body;
        throw Exception('Error ${response.statusCode}: $body');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
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

  Future<void> reload() async {
    state = AsyncValue.loading();
    await fetchUsers();
  }
}
