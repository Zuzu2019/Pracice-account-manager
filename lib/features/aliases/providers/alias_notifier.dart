import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/aliases/data/alias_service.dart';
import 'package:practice_acount_manager/features/aliases/models/aliases.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

class AliasNotifier extends StateNotifier<AsyncValue<List<Aliases>>> {
  final AliasService _service;
  final Ref _ref;

  String _searchQuery = '';
  List<Aliases> _allAlias = [];

  AliasNotifier(this._service, this._ref) : super(AsyncValue.loading()) {
    fetchAlias();
  }

  Future<void> fetchAlias() async {
    state = const AsyncValue.loading();
    try {
      final token = _ref.read(authProvider).accessToken;
      final aliases = await _service.getAlias(token);

      _allAlias = aliases;
      _applyFilter();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addAlias(Aliases alias) async {
    state = const AsyncValue.loading();
    try {
      final token = _ref.read(authProvider).accessToken;
      await _service.saveAlias(alias, token);
      await fetchAlias();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateAlias(Aliases alias, int id) async {
    state = const AsyncValue.loading();
    try {
      final token = _ref.read(authProvider).accessToken;
      await _service.updateAlias(id, alias, token);
      await fetchAlias();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> deleteAlias(int id) async {
    state = const AsyncValue.loading();
    try {
      final token = _ref.read(authProvider).accessToken;
      final resp = await _service.deleteAlias(id, token);

      if (resp.statusCode == 200) {
        state = state.whenData(
          (alias) => alias.where((u) => u.id != id).toList(),
        );
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
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
}
