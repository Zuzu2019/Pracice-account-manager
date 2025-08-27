import 'package:practice_acount_manager/features/users/presentation/models/users.dart';

class UserResponse {
  final int totalCount;
  final int totalPages;
  final List<User> users;

  UserResponse({
    required this.totalCount,
    required this.totalPages,
    required this.users,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    final users =
        (json['Users'] as List<dynamic>?)
            ?.map((e) => User.fromJson(e))
            .toList() ??
        (json['Items'] as List<dynamic>?)
            ?.map((e) => User.fromJson(e))
            .toList() ??
        [];

    return UserResponse(
      totalCount: json['TotalCount'] ?? 0,
      totalPages: json['TotalPages'] ?? 1,
      users: users, // si es null, lista vacía
    );
  }
}
