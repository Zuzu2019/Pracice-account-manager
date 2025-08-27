import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/aliases/data/alias_service.dart';
import 'package:practice_acount_manager/features/aliases/models/aliases.dart';
import 'package:practice_acount_manager/features/aliases/providers/alias_provider.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

class AliasNotifier extends StateNotifier<AsyncValue<List<Aliases>>> {
  final AliasService _service;
  final Ref _ref;

  String _searchQuery = '';
  List<Aliases> _allAlias = [];

  AliasNotifier(this._service, this._ref) : super(AsyncValue.loading()) {
    fetchAlias();
  }

  AuthState get _auth => _ref.read(authProvider);

  Future<void> fetchAlias() async {
    try {
      final aliases = await _service.getAlias(
        _auth.accessToken,
        _auth.refreshToken,
      );
      _allAlias = aliases.alias;
      _applyFilter();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addAlias(Aliases alias) async {
    try {
      final response = await _service.saveAlias(
        alias,
        _auth.accessToken,
        _auth.refreshToken,
      );

      if (response.statusCode == 200) {
        final manager = _ref.read(aliasPagingProvider);
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

  Future<void> updateAlias(Aliases alias, int id) async {
    try {
      final response = await _service.updateAlias(
        id,
        alias,
        _auth.accessToken,
        _auth.refreshToken,
      );
      if (response.statusCode == 200) {
        final manager = _ref.read(aliasPagingProvider);
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

  Future<bool> deleteAlias(int id) async {
    try {
      final resp = await _service.deleteAlias(
        id,
        _auth.accessToken,
        _auth.refreshToken,
      );

      if (resp.statusCode == 200) {
        final manager = _ref.read(aliasPagingProvider);
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

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
  }

  void _applyFilter() {
    final filtered = _searchQuery.isEmpty
        ? _allAlias
        : _allAlias.where((u) {
            return u.local.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                u.remoto.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

    state = AsyncValue.data(filtered);
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    await fetchAlias();
  }
}
