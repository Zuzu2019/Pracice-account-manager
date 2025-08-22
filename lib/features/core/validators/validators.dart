import 'package:ez_validator/ez_validator.dart';

final EzSchema usersFormSchema = EzSchema.shape({
  "login": EzValidator<String>(
    label: "Login",
  ).required().minLength(4).maxLength(255),

  "email": EzValidator<String>(
    label: "Email",
  ).required().email().maxLength(255),

  "password": EzValidator<String>(label: "Password").minLength(8).addMethod((
    value,
  ) {
    return value != null && RegExp(r'[!¡@#$%&=¿?*\-_.]').hasMatch(value);
  }),

  "maildir": EzValidator<String>(label: "Maildir").required(),

  "identificacion": EzValidator<String>(label: "Identificación").maxLength(255),

  "grupo": EzValidator<String>(label: "Grupo").maxLength(255),

  "dominio": EzValidator<int>(label: "Dominio").required().min(1),

  "quota": EzValidator<int>(label: "Quota").min(0),
});

final EzSchema aliasFormSchema = EzSchema.shape({
  "local": EzValidator<String>(
    label: "Local",
  ).required().email().maxLength(255),

  "remoto": EzValidator<String>(
    label: "Remoto",
  ).required().email().maxLength(255),
});
