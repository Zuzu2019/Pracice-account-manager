
import 'package:practice_acount_manager/features/auth/model/entities.dart';

class AuthZitadelMapper {
  static AuthZitadel jsonToentity(Map<String, dynamic> json) {
    return AuthZitadel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      idToken: json['id_token'],
      expiresIn: json['expires_in'],
      tokenType: json['token_type'],
    );
  }
}
