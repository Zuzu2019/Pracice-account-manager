import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/users/data/users_service.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';
import 'package:practice_acount_manager/features/users/provider/user_notifier.dart';

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<List<User>>>((ref) {
      final service = UsersService();
      return UserNotifier(service, ref);
    });
