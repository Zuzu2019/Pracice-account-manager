// Define User solo si lo necesitas, sino quita esta clase
class User {
  final String login;
  final String email;
  final String maildir;
  final String identificacion;
  final String grupo;
  final String quota;

  User({
    required this.login,
    required this.email,
    required this.maildir,
    required this.identificacion,
    required this.grupo,
    required this.quota,
  });
}
