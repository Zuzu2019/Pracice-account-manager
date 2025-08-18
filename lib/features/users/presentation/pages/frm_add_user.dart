import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/users/data/users_service.dart';
import 'package:practice_acount_manager/features/users/presentation/components/input_password_confirm_user.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_cancel.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_user_navigation.dart';
import 'package:practice_acount_manager/features/widgets/generals/footer.dart';
import 'package:practice_acount_manager/features/users/presentation/components/input_password_user.dart';
import 'package:practice_acount_manager/features/widgets/generals/text_form_field.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

class AddUserForm extends ConsumerStatefulWidget {
  const AddUserForm({super.key});

  @override
  ConsumerState<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends ConsumerState<AddUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final accessToken = ref.read(authProvider).accessToken;

  //late final TextEditingController _passwordCotroller;
  late final TextEditingController _loginController;
  late final TextEditingController _identificacionController;
  late final TextEditingController _groupController;
  late final TextEditingController _quotaController;
  late final TextEditingController _dominioController;

  late final TextEditingController _emailController;

  String? dominio;
  List listDominios = [];
  String? _selectedDomain;

  @override
  void initState() {
    super.initState();

    // Nueva inserción: campos vacíos
    _loginController = TextEditingController();
    _identificacionController = TextEditingController();
    _groupController = TextEditingController();
    _quotaController = TextEditingController();
    _dominioController = TextEditingController();
    _emailController = TextEditingController();

    _loginController.addListener(_updateEmail);
    _dominioController.addListener(_updateEmail);

    _getDominios();
  }

  //Para que se actualice el campo de email
  void _updateEmail() {
    final login = _loginController.text.trim();
    final dominio = _dominioController.text.trim();

    if (login.isNotEmpty && dominio.isNotEmpty) {
      _emailController.text = '$login$dominio';
    } else {
      _emailController.clear();
    }
  }

  void _submitForm(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      final userAdd = User(
        dominio: int.tryParse(_selectedDomain ?? '0') ?? 0,
        id: 0,
        login: _loginController.text.trim(),
        password: _passwordController.text.trim(),
        email: _emailController.text.trim(),
        maildir: '/prueba',
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
        final resp = await saveUser(userAdd, accessToken);

        if (resp.statusCode == 200) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: loc.success_title,
            desc: loc.user_added_successfully,
            btnOkOnPress: () {
              _formKey.currentState!.reset();
              _loginController.clear();
              _passwordController.clear();
              _confirmPasswordController.clear();
              _identificacionController.clear();
              _groupController.clear();
              _quotaController.clear();
            },
            btnOkColor: Colors.green,
          ).show();
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: loc.error_title,
            desc: resp.body,
            btnOkOnPress: () {},
            btnOkColor: Colors.red,
          ).show();
        }
      } catch (e) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: loc.error_title,
          desc: e.toString(),
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  void _getDominios() async {
    try {
      final resp = await getDominios(accessToken);

      setState(() {
        listDominios = resp;

        _selectedDomain = listDominios
            .firstWhere(
              (dom) => dom['Domain'] == _dominioController.text,
              orElse: () => null,
            )
            .toString();
      });
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        desc: e.toString(),
        btnOkOnPress: () {},
        btnOkColor: Colors.red,
      ).show();
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
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.title_add_user, // Usar la localización
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
                        label_text: loc.label_password,
                        controller: _passwordController,
                        edit: false,
                      ),
                      const SizedBox(height: 16),
                      ConfirmPasswordField(
                        controller: _confirmPasswordController,
                        originalPasswordController: _passwordController,
                        edit: false,
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
                          labelText: loc.label_domain, //'Dominio',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 25, 0, 255),
                            fontWeight: FontWeight.bold,
                          ),
                          hintText:
                              loc.domain_required, //'Selecciona un dominio',
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
                        value: '1',
                        //value: _dominioController.text,
                        items: listDominios.map<DropdownMenuItem<String>>((
                          dom,
                        ) {
                          return DropdownMenuItem<String>(
                            value: dom['ID'].toString(),
                            child: Text(dom['Domain']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDomain = value;
                            final domSeleccionado = listDominios.firstWhere(
                              (dom) => dom['ID'].toString() == value,
                            );
                            _dominioController.text = domSeleccionado['Domain'];
                          });
                        },
                        validator: (value) =>
                            value == null ? loc.hint_domain : null,
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
                            onPressed: () => _submitForm(context),
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
                            child: Text(loc.button_add),
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
