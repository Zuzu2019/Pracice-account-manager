import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/users/data/users_service.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';
import 'package:practice_acount_manager/features/users/provider/user_form_notifier.dart';
import 'package:practice_acount_manager/features/users/provider/user_notifier.dart';
import 'package:practice_acount_manager/features/users/provider/user_paging_provider.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<List<User>>>((ref) {
      final service = UsersService();
      return UserNotifier(service, ref);
    });

final usersPagingProvider = ChangeNotifierProvider<UsersPagingManager>((ref) {
  final auth = ref.watch(authProvider);
  return UsersPagingManager(
    service: UsersService(),
    accessToken: auth.accessToken,
    refreshToken: auth.refreshToken,
  );
});

final userFormProvider = StateNotifierProvider<UserFormNotifier, User>((ref) {
  final service = UsersService();
  final auth = ref.read(authProvider);
  return UserFormNotifier(
    User(
      id: 0,
      dominio: 0,
      login: '',
      password: '',
      email: '',
      maildir: '',
      identificacion: '',
      grupo: '',
      quota: 0,
    ),
    service,
    auth.accessToken,
    auth.refreshToken,
  );
});
