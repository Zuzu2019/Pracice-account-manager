import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:practice_acount_manager/features/auth/presentation/pages/select_login_page.dart';
import 'package:practice_acount_manager/features/auth/presentation/service/auth_service_local.dart';
import 'package:practice_acount_manager/features/core/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final String? accessToken;
  final String? refreshToken;
  final Map<String, dynamic>? userInfo;

  AuthState({this.accessToken, this.refreshToken, this.userInfo});

  AuthState copyWith({
    String? accessToken,
    String? refreshToken,
    Map<String, dynamic>? userInfo,
  }) {
    return AuthState(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userInfo: userInfo ?? this.userInfo,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  Timer? _timer;
  final LoginService _loginService = LoginService();

  AuthNotifier() : super(AuthState());

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();

    final access = prefs.getString('id_token') ?? '';
    final refresh = prefs.getString('refresh_token') ?? '';

    // Leer userInfo como string
    final userJson = prefs.getString('user_info');
    Map<String, dynamic>? userInfo;
    if (userJson != null && userJson.isNotEmpty) {
      userInfo = jsonDecode(userJson);
    }

    // Guardar en el state
    state = AuthState(
      accessToken: access,
      refreshToken: refresh,
      userInfo: userInfo,
    );
  }

  void setTokens({required String accessToken, required String refreshToken}) {
    state = state.copyWith(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    _startTokenMonitor();
  }

  void clearTokens() {
    state = AuthState();
    _stopTokenMonitor();
  }

  void _startTokenMonitor() {
    _stopTokenMonitor();

    if (state.accessToken == null) return;

    final expDate = Jwt.getExpiryDate(state.accessToken!);
    final duration = expDate?.difference(DateTime.now());

    _timer = Timer(duration!, _logoutGlobal);
  }

  void _stopTokenMonitor() {
    _timer?.cancel();
  }

  Future<void> _logoutGlobal() async {
    _stopTokenMonitor();
    clearTokens();
    await _loginService.logoutLocal();

    // Redirigir al login
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SelectLoginPage()),
      (route) => false,
    );
  }
}

// Provider global
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
