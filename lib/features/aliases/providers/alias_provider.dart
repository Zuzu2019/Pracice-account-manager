import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/aliases/data/alias_service.dart';
import 'package:practice_acount_manager/features/aliases/models/aliases.dart';
import 'package:practice_acount_manager/features/aliases/providers/alias_notifier.dart';
import 'package:practice_acount_manager/features/aliases/providers/alias_paging_provider.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

final aliasProvider =
    StateNotifierProvider<AliasNotifier, AsyncValue<List<Aliases>>>((ref) {
      final service = AliasService();
      return AliasNotifier(service, ref);
    });

final aliasPagingProvider = ChangeNotifierProvider<AliasPagingManager>((ref) {
  final auth = ref.watch(authProvider);
  return AliasPagingManager(
    service: AliasService(),
    accessToken: auth.accessToken,
    refreshToken: auth.refreshToken,
  );
});
