import 'package:practice_acount_manager/features/users/presentation/models/users.dart';

class UserState {
  final List<User> users;
  final bool isLoadingMore;
  final bool hasMore;

  UserState({
    required this.users,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  UserState copyWith({List<User>? users, bool? isLoadingMore, bool? hasMore}) {
    return UserState(
      users: users ?? this.users,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
