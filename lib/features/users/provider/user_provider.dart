import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:practice_acount_manager/features/users/data/users_service.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

final usersProvider = FutureProvider<List<User>>((ref) async {
  late final accessToken = ref.read(authProvider).accessToken;
  return getUsers(accessToken);
});

final deleteUserProvider = FutureProvider.family<http.Response, int>((
  ref,
  id,
) async {
  final accessToken = ref.read(authProvider).accessToken;
  return deleteUser(id, accessToken);
});

final searchQueryProvider = StateProvider<String>((ref) => '');
