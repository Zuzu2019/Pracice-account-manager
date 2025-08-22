import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:practice_acount_manager/features/users/data/users_service.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

class UsersPagingManager extends ChangeNotifier {
  static const _pageSize = 10;
  final AuthState _auth;
  final _service = UsersService();

  PagingState<int, User> state = PagingState(
    pages: [],
    keys: [],
    isLoading: false,
    hasNextPage: true,
  );

  UsersPagingManager(this._auth) {
    // Carga la primera página automáticamente
    fetchNextPage('');
  }

  Future<void> fetchNextPage(String query) async {
    if (state.isLoading || !state.hasNextPage) return;

    final currentPage = state.keys?.last ?? 1;

    state = state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final response = await _service.getUsers(
        _auth.accessToken,
        _auth.refreshToken,
        page: currentPage,
        limit: _pageSize,
      );

      final isLastPage = currentPage >= response.totalPages;

      if (response.users.isNotEmpty) {
        state = state.copyWith(
          pages: [...?state.pages, response.users],
          keys: [...?state.keys, currentPage + 1],
          hasNextPage: !isLastPage,
          isLoading: false,
        );
      } else {
        // No hay datos, marcamos que no hay siguiente página
        state = state.copyWith(hasNextPage: false, isLoading: false);
      }

      notifyListeners();
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error);
      notifyListeners();
    }
  }

  void reset() {
    state = PagingState(
      pages: [],
      keys: [],
      isLoading: false,
      hasNextPage: true,
    );
    // Recarga la primera página automáticamente
    fetchNextPage('');
    notifyListeners();
  }
}
