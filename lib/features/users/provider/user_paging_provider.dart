import 'dart:async';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:practice_acount_manager/features/users/data/users_service.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';

class UsersPagingManager extends ChangeNotifier {
  static const _pageSize = 10;

  final UsersService _service;
  final String? accessToken;
  final String? refreshToken;

  PagingState<int, User> state = PagingState(
    pages: [],
    keys: [],
    isLoading: false,
    hasNextPage: true,
  );

  String _currentQuery = '';
  Timer? _debounce;

  UsersPagingManager({
    required UsersService service,
    this.accessToken,
    this.refreshToken,
  }) : _service = service;

  /// 🔄 Actualiza la query de búsqueda con debounce
  void setSearchQuery(String query) {
    // Cancelar timer previo
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _currentQuery = query;
      reset(); // Reinicia la paginación con la nueva query
    });
  }

  /// 🔄 Reinicia la paginación
  Future<void> reset() async {
    state = PagingState(
      pages: [],
      keys: [],
      isLoading: false,
      hasNextPage: true,
    );
    notifyListeners(); // notificar que se limpió la lista
    await fetchNextPage(); // carga inicial con la query actual
  }

  /// 📄 Carga la siguiente página
  Future<void> fetchNextPage() async {
    if (state.isLoading || !state.hasNextPage) return;

    final currentPage = state.keys?.isNotEmpty == true ? state.keys!.last : 1;

    state = state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final response = await _service.getUsers(
        accessToken,
        refreshToken,
        page: currentPage,
        limit: _pageSize,
        query: _currentQuery, // <--- tu query aquí
      );

      final users = response.users ?? [];
      final isLastPage = currentPage >= response.totalPages;

      state = state.copyWith(
        pages: [...?state.pages, users],
        keys: [...?state.keys, if (!isLastPage) currentPage + 1],
        hasNextPage: !isLastPage,
        isLoading: false,
      );
      notifyListeners();
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
