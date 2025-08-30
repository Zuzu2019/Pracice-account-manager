class PasswordChange {
  final String password;
  final String newPassword;
  final String confirmPassword;

  PasswordChange({
    required this.password,
    required this.newPassword,
    required this.confirmPassword,
  });

  // Constructor desde un Map (JSON)
  factory PasswordChange.fromJson(Map<String, dynamic> json) {
    return PasswordChange(
      password: json['password'] ?? '',
      newPassword: json['newPassword'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
    );
  }

  // Convertir a Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}
