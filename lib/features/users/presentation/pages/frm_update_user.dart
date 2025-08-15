import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:practice_acount_manager/features/users/data/users_service.dart'
    show updateUser;
import 'package:practice_acount_manager/features/users/presentation/components/input_password_confirm_user.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_cancel.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_user_navigation.dart';
import 'package:practice_acount_manager/features/widgets/generals/footer.dart';
import 'package:practice_acount_manager/features/users/presentation/components/input_password_user.dart';
import 'package:practice_acount_manager/features/widgets/generals/text_form_field.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';

class UpdateUserForm extends StatefulWidget {
  final User user;

  const UpdateUserForm({super.key, required this.user});

  @override
  State<UpdateUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<UpdateUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final TextEditingController _loginController;
  late final TextEditingController _identificacionController;
  late final TextEditingController _groupController;
  late final TextEditingController _quotaController;
  late final TextEditingController _dominioController;
  late final TextEditingController _emailController;

  String? _selectedDomain;
  String? dominio;

  get onLocaleChange => null;

  @override
  void initState() {
    super.initState();

    final email = widget.user.email;
    final dominio = email.contains('@') ? email.split('@')[1] : '';

    _loginController = TextEditingController(text: widget.user.login);
    _identificacionController = TextEditingController(
      text: widget.user.identificacion,
    );
    _groupController = TextEditingController(text: widget.user.grupo);
    _quotaController = TextEditingController(
      text: widget.user.quota.toString(),
    );
    _dominioController = TextEditingController(text: dominio);
    _emailController = TextEditingController(text: email);

    _loginController.addListener(_updateEmail);
    _dominioController.addListener(_updateEmail);
  }

  void _updateEmail() {
    final login = _loginController.text.trim();
    final dominio = _dominioController.text.trim();

    if (login.isNotEmpty && dominio.isNotEmpty) {
      _emailController.text = '$login$dominio';
    } else {
      _emailController.clear();
    }
  }

  void _submitForm() async {
    final loc = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      final user = User(
        dominio: 1,
        id: widget.user.id,
        login: _loginController.text.trim(),
        password: _passwordController.text.trim(),
        email: _emailController.text.trim(),
        maildir: '',
        identificacion: _identificacionController.text.trim(),
        grupo: _groupController.text.trim(),
        quota: int.tryParse(_quotaController.text.trim()) ?? 0,
      );

      if (_passwordController.text != _confirmPasswordController.text) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: loc.error_title,
          desc: loc.password_mismatch,
          btnOkOnPress: () {},
        ).show();
        return;
      }

      try {
        final resp = await updateUser(user.id, user, 'token');

        if (resp.statusCode == 200) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: loc.user_updated,
            desc: loc.user_updated_successfully,
            btnOkOnPress: () {
              Navigator.pop(context, user);
            },
            btnOkColor: Colors.green,
          ).show();
        } else {
          String errorMessage = resp.body.isNotEmpty
              ? resp.body
              : 'Error inesperado: Código ${resp.statusCode}';

          await AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: loc.error_title,
            desc: errorMessage,
            btnOkOnPress: () {
              Navigator.pop(context);
            },
            btnOkColor: Colors.red,
          ).show();
        }
      } catch (e) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: e.toString(),
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _identificacionController.dispose();
    _groupController.dispose();
    _quotaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final title = loc.edit_user_title;
    final btnText = loc.update_button;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 54, 84, 255),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5),
            top: Radius.circular(5),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ButtonOptions(),
            const SizedBox(height: 30),
            const SizedBox(height: 16),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: Color.fromARGB(255, 61, 130, 240),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: _loginController,
                        label: loc.label_login,
                        hint: loc.hint_login,
                        icon: Icons.person,
                        validator: (value) => value == null || value.isEmpty
                            ? loc.field_required
                            : null,
                      ),

                      const SizedBox(height: 16),

                      PasswordField(
                        controller: _passwordController,
                        edit: true,
                      ),
                      const SizedBox(height: 16),
                      ConfirmPasswordField(
                        controller: _confirmPasswordController,
                        originalPasswordController: _passwordController,
                        edit: true,
                      ),
                      const SizedBox(height: 16),

                      CustomTextFormField(
                        controller: _identificacionController,
                        label: loc.label_id,
                        hint: loc.hint_id,
                        icon: Icons.verified_user,
                        validator: (value) => value == null || value.isEmpty
                            ? loc.field_required
                            : null,
                      ),

                      const SizedBox(height: 16),

                      CustomTextFormField(
                        controller: _groupController,
                        label: loc.label_group,
                        hint: loc.hint_group,
                        icon: Icons.group,
                        validator: (value) => value == null || value.isEmpty
                            ? loc.field_required
                            : null,
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: loc.label_domain,
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 25, 0, 255),
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: loc.hint_domain,
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.domain,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 61, 130, 240),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 61, 130, 240),
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        value: _dominioController.text.isNotEmpty
                            ? _dominioController.text
                            : null,
                        //value: _dominioController.text,
                        items: const [
                          DropdownMenuItem(
                            value: 'example.com',
                            child: Text('example.com'),
                          ),
                          DropdownMenuItem(
                            value: 'ejemplo.com',
                            child: Text('ejemplo.com'),
                          ),
                          DropdownMenuItem(
                            value: 'prueba2.com',
                            child: Text('prueba2.com'),
                          ),
                          DropdownMenuItem(
                            value: 'email.com',
                            child: Text('email.com'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedDomain = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? loc.domain_required : null,
                      ),

                      const SizedBox(height: 16),

                      CustomTextFormField(
                        controller: _quotaController,
                        label: loc.label_quota,
                        hint: loc.hint_quota,
                        icon: Icons.storage,
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? loc.field_required
                            : null,
                      ),

                      const SizedBox(height: 16),

                      CustomTextFormField(
                        controller: _emailController,
                        label: loc.email,
                        hint: '',
                        icon: Icons.email,
                        readOnly: true,
                        validator: (value) => value == null || value.isEmpty
                            ? loc.field_required
                            : null,
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                39,
                                122,
                                47,
                              ),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(btnText),
                          ),
                          const SizedBox(width: 16),
                          const ButtonCancel(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
