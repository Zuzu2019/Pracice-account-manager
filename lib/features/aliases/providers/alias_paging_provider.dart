import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:practice_acount_manager/features/aliases/data/alias_service.dart';
import 'package:practice_acount_manager/features/aliases/models/aliases.dart';

class AliasPagingManager extends ChangeNotifier {
  static const _pageSize = 10;

  final AliasService _service;
  final String? accessToken;
  final String? refreshToken;

  String _currentQuery = '';
  Timer? _debounce;

  PagingState<int, Aliases> state = PagingState(
    pages: [],
    keys: [],
    isLoading: false,
    hasNextPage: true,
  );

  AliasPagingManager({
    required AliasService service,
    required this.accessToken,
    required this.refreshToken,
  }) : _service = service;

  void setSearchQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _currentQuery = query;
      reset();
    });
  }

  void reset() async {
    state = PagingState(
      pages: [],
      keys: [],
      isLoading: false,
      hasNextPage: true,
    );
    notifyListeners();
    await fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || !state.hasNextPage) return;

    final currentPage = state.keys?.isNotEmpty == true ? state.keys!.last : 1;

    state = state.copyWith(isLoading: true, error: null);
    notifyListeners();

    try {
      final response = await _service.getAlias(
        accessToken,
        refreshToken,
        page: currentPage,
        limit: _pageSize,
        query: _currentQuery,
      );

      final alias = response.alias ?? [];
      final isLastPage = currentPage >= response.totalPages;

      if (isLastPage) {
        state = state.copyWith(
          pages: [...?state.pages, alias],
          keys: [...?state.keys, currentPage],
          hasNextPage: false,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          pages: [...?state.pages, alias],
          keys: [...?state.keys, currentPage],
          hasNextPage: true,
          isLoading: false,
        );
      }

      notifyListeners();
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error);
      notifyListeners();
    }
  }

  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
