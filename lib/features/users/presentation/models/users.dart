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
    return User(
      id: json['ID'] != null ? int.parse(json['ID'].toString()) : 0,
      dominio: json['Dominio'] != null
          ? int.parse(json['Dominio'].toString())
          : 0,
      login: json['Login']?.toString() ?? '',
      password: json['Password']?.toString() ?? '',
      email: json['Email']?.toString() ?? '',
      maildir: json['Maildir']?.toString() ?? '',
      identificacion: json['Identificacion']?.toString() ?? '',
      grupo: json['Grupo'],
      quota: json['Quota'] != null ? int.parse(json['Quota'].toString()) : 0,
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
}
