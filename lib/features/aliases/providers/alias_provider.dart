import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/aliases/data/alias_service.dart';
import 'package:practice_acount_manager/features/aliases/models/aliases.dart';
import 'package:practice_acount_manager/features/aliases/providers/alias_notifier.dart';

final aliasProvider =
    StateNotifierProvider<AliasNotifier, AsyncValue<List<Aliases>>>((ref) {
      final service = AliasService();
      return AliasNotifier(service, ref);
    });
