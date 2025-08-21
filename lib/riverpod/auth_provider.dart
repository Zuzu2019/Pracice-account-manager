import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final String? accessToken;
  final String? refreshToken;

  AuthState({this.accessToken, this.refreshToken});

  AuthState copyWith({String? accessToken, String? refreshToken}) {
    return AuthState(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void setTokens({required String accessToken, required String refreshToken}) {
    state = state.copyWith(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  void clearTokens() {
    state = AuthState();
  }
}

// Provider global
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
