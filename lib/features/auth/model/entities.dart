class AuthZitadel {
  final String accessToken;
  final String refreshToken;
  final String idToken;
  final int expiresIn;
  final String tokenType;

  AuthZitadel({
    required this.accessToken,
    required this.refreshToken,
    required this.idToken,
    required this.expiresIn,
    required this.tokenType,
  });
}
