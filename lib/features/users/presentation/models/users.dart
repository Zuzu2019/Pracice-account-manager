// Define User solo si lo necesitas, sino quita esta clase
class User {
  final int id;
  final int dominio;
  final String login;
  final String email;
  final String maildir;
  final String identificacion;
  final String password;
  final String grupo;
  final int quota;

  User({
    required this.id,
    required this.dominio,
    required this.login,
    required this.password,
    required this.email,
    required this.maildir,
    required this.identificacion,
    required this.grupo,
    required this.quota,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final normalized = {
      for (var entry in json.entries) entry.key.toLowerCase(): entry.value,
    };

    return User(
      id: int.tryParse(normalized['id']?.toString() ?? '') ?? 0,
      dominio: int.tryParse(normalized['dominio']?.toString() ?? '') ?? 0,
      login: normalized['login']?.toString() ?? '',
      password: normalized['password']?.toString() ?? '',
      email: normalized['email']?.toString() ?? '',
      maildir: normalized['maildir']?.toString() ?? '',
      identificacion: normalized['identificacion']?.toString() ?? '',
      grupo: normalized['grupo']?.toString() ?? '',
      quota: int.tryParse(normalized['quota']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dominio': dominio,
      'login': login,
      'password': password,
      'email': email,
      'maildir': maildir,
      'identificacion': identificacion,
      'grupo': grupo,
      'quota': quota,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "login": login,
      "email": email,
      "password": password,
      "maildir": maildir,
      "identificacion": identificacion,
      "grupo": grupo,
      "dominio": dominio,
      "quota": quota,
    };
  }
}

extension UserCopyWith on User {
  User copyWith({
    int? id,
    int? dominio,
    String? login,
    String? password,
    String? email,
    String? maildir,
    String? identificacion,
    String? grupo,
    int? quota,
  }) {
    return User(
      id: id ?? this.id,
      dominio: dominio ?? this.dominio,
      login: login ?? this.login,
      password: password ?? this.password,
      email: email ?? this.email,
      maildir: maildir ?? this.maildir,
      identificacion: identificacion ?? this.identificacion,
      grupo: grupo ?? this.grupo,
      quota: quota ?? this.quota,
    );
  }
}
