import 'package:ez_validator/ez_validator.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';

Map<String, String>? validateUser(User user, {required bool isEditing}) {
  final usersFormSchema = EzSchema.shape({
    "login": EzValidator<String>(
      label: "Login",
    ).required().minLength(4).maxLength(255),

    "email": EzValidator<String>(
      label: "Email",
    ).required().email().maxLength(255),

    if (!isEditing)
      "password": EzValidator<String>(label: "Password")
          .required()
          .minLength(8)
          .addMethod((value) {
            return value != null &&
                RegExp(r'[!¡@#$%&=¿?*\-_.]').hasMatch(value);
          }),

    "maildir": EzValidator<String>(label: "Maildir").required(),

    "identificacion": EzValidator<String>(
      label: "Identificación",
    ).maxLength(255),

    "grupo": EzValidator<String>(label: "Grupo").maxLength(255),

    "dominio": EzValidator<int>(label: "Dominio").required().min(1),

    "quota": EzValidator<int>(label: "Quota").min(0),
  });

  final (_, errors) = usersFormSchema.validateSync(user.toMap());

  // Convertimos Map<dynamic, dynamic> a Map<String, String>
  final stringErrors = errors.map(
    (key, value) => MapEntry(key.toString(), value.toString()),
  );

  // Retornamos null si no hay errores
  return stringErrors.isEmpty ? null : stringErrors;
}
