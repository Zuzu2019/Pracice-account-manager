import 'package:practice_acount_manager/features/users/presentation/models/users.dart'
    show User;

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
    return UserResponse(
      totalCount: json['TotalCount'],
      totalPages: json['TotalPages'],
      users: (json['Users'] as List).map((e) => User.fromJson(e)).toList(),
    );
  }
}
