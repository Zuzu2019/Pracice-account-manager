import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/core/validators/validators.dart';
import 'package:practice_acount_manager/features/dominios/provider/dominio_service.dart';
import 'package:practice_acount_manager/features/users/presentation/components/input_password_confirm_user.dart';
import 'package:practice_acount_manager/features/users/presentation/models/password.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';
import 'package:practice_acount_manager/features/users/provider/user_provider.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_cancel.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_user_navigation.dart';
import 'package:practice_acount_manager/features/users/presentation/components/input_password_user.dart';
import 'package:practice_acount_manager/features/widgets/generals/text_form_field.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

class UpdateUserForm extends ConsumerStatefulWidget {
  final User user;

  const UpdateUserForm({super.key, required this.user});

  @override
  ConsumerState<UpdateUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends ConsumerState<UpdateUserForm> {
  final _generalFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordNewController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final accessToken = ref.read(authProvider).accessToken;

  late final TextEditingController _loginController;
  late final TextEditingController _identificacionController;
  late final TextEditingController _groupController;
  late final TextEditingController _quotaController;
  late final TextEditingController _dominioController;
  late final TextEditingController _emailController;

  String? _selectedDomain;
  String? dominio;
  List listDominios = [];

  get onLocaleChange => null;

  @override
  void initState() {
    super.initState();

    final email = widget.user.email;
    final dominio = email.contains('@') ? '@${email.split('@')[1]}' : '';

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

    setState(() {
      if (login.isNotEmpty && dominio.isNotEmpty) {
        _emailController.text = '$login$dominio';
      } else {
        _emailController.clear();
      }
    });
  }

  void _submitForm(WidgetRef ref) async {
    final loc = AppLocalizations.of(context)!;
    final isGeneralValid = _generalFormKey.currentState?.validate() ?? false;

    //if (isGeneralValid) {

    final user = User(
      dominio: _selectedDomain != null
          ? int.tryParse(_selectedDomain!) ?? widget.user.dominio
          : widget.user.dominio,
      id: widget.user.id,
      login: _loginController.text.trim(),
      password: _passwordController.text.trim(),
      email: _emailController.text.trim(),
      maildir: '/prueba',
      identificacion: _identificacionController.text.trim(),
      grupo: _groupController.text.trim(),
      quota: int.tryParse(_quotaController.text.trim()) ?? 0,
    );

    final errors = validateUser(user, isEditing: true);

    if (errors != null && errors.isNotEmpty) {
      // Mostrar primer error
      final firstKey = errors.keys.first;
      final firstMessage = errors[firstKey];
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        desc: firstMessage ?? 'Error en el formulario',
        btnOkOnPress: () {},
        btnOkColor: Colors.red,
      ).show();
      return;
    }
    try {
      final resp = await ref
          .read(userProvider.notifier)
          .updateUsers(user, user.id);
      if (resp) {
        final manager = ref.read(usersPagingProvider);
        manager.reset();
        await manager.fetchNextPage();
      }

      _showDialog(
        context: context,
        title: loc.user_updated,
        description: loc.user_updated_successfully,
        type: DialogType.success,
        btnColor: Colors.green,
        onOk: () => Navigator.pop(context),
      );
    } catch (e) {
      _showDialog(
        context: context,
        title: loc.error_title,
        description: e.toString(),
        type: DialogType.error,
        btnColor: Colors.red,
        onOk: () => Navigator.pop(context),
      );
    }
    //}

    // --- Actualización de contraseña ---
    final hasPasswordInput =
        _passwordController.text.isNotEmpty ||
        _passwordNewController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty;

    if (hasPasswordInput) {
      final isPasswordValid = _passwordFormKey.currentState?.validate() ?? true;
      if (!isPasswordValid) return;

      if (_passwordNewController.text.trim() !=
          _confirmPasswordController.text.trim()) {
        _showDialog(
          context: context,
          title: loc.error_title,
          description: loc.password_mismatch,
          type: DialogType.error,
          btnColor: Colors.red,
        );
        return;
      }

      final passwords = PasswordChange(
        password: _passwordController.text.trim(),
        newPassword: _passwordNewController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
      );

      try {
        await ref
            .read(userProvider.notifier)
            .updatePassword(widget.user.id, passwords);
        _showDialog(
          context: context,
          title: loc.success_title,
          description: loc.password_updated,
          type: DialogType.success,
          btnColor: Colors.green,
          onOk: () {
            _passwordController.clear();
            _passwordNewController.clear();
            _confirmPasswordController.clear();
            Navigator.pop(context);
          },
        );
      } catch (e) {
        _showDialog(
          context: context,
          title: loc.error_title,
          description: e.toString(),
          type: DialogType.error,
          btnColor: Colors.red,
        );
      }
    }
  }

  // Función auxiliar para mostrar diálogos
  void _showDialog({
    required BuildContext context,
    required String title,
    required String description,
    DialogType type = DialogType.info,
    Color? btnColor,
    VoidCallback? onOk,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      title: title,
      desc: description,
      btnOkOnPress: onOk ?? () {},
      btnOkColor: btnColor,
    ).show();
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

    final dominiosAsync = ref.watch(dominiosProvider);

    return DefaultTabController(
      length: 2, // Dos pestañas: General y Contraseña
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(
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

        body: dominiosAsync.when(
          data: (dominios) => SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ButtonOptions(),
                const SizedBox(height: 16),

                // ------------------ Tabs ------------------
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.blue,
                        tabs: const [
                          Tab(text: 'General'),
                          Tab(text: 'Contraseña'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        height: 600,
                        child: TabBarView(
                          children: [
                            // ------------------ TAB 1: General ------------------
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(
                                        color: Color.fromARGB(
                                          255,
                                          61,
                                          130,
                                          240,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Form(
                                        key: _generalFormKey,
                                        child: Column(
                                          children: [
                                            CustomTextFormField(
                                              controller: _loginController,
                                              label: loc.label_login,
                                              hint: loc.hint_login,
                                              icon: Icons.person,
                                              validator: (value) =>
                                                  value == null || value.isEmpty
                                                  ? loc.field_required
                                                  : null,
                                            ),
                                            const SizedBox(height: 16),
                                            CustomTextFormField(
                                              controller: _groupController,
                                              label: loc.label_group,
                                              hint: loc.hint_group,
                                              icon: Icons.group,
                                              validator: (value) =>
                                                  value == null || value.isEmpty
                                                  ? loc.field_required
                                                  : null,
                                            ),
                                            const SizedBox(height: 16),

                                            DropdownButtonFormField<String>(
                                              decoration: InputDecoration(
                                                labelText: loc.label_domain,
                                                labelStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                    255,
                                                    25,
                                                    0,
                                                    255,
                                                  ),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                hintText: loc.domain_required,
                                                hintStyle: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                prefixIcon: const Icon(
                                                  Icons.domain,
                                                  color: Colors.black,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      borderSide:
                                                          const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                  255,
                                                                  61,
                                                                  130,
                                                                  240,
                                                                ),
                                                            width: 1.5,
                                                          ),
                                                    ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      borderSide:
                                                          const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                  255,
                                                                  61,
                                                                  130,
                                                                  240,
                                                                ),
                                                            width: 2,
                                                          ),
                                                    ),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: const BorderSide(
                                                    color: Colors.red,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      borderSide:
                                                          const BorderSide(
                                                            color: Colors.red,
                                                            width: 2,
                                                          ),
                                                    ),
                                                filled: true,
                                                fillColor: Colors.white,
                                              ),
                                              value: (widget.user.dominio)
                                                  .toString(),
                                              items: dominios
                                                  .map<
                                                    DropdownMenuItem<String>
                                                  >((dom) {
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value: dom['ID']
                                                          .toString(),
                                                      child: Text(
                                                        dom['Domain'],
                                                      ),
                                                    );
                                                  })
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedDomain = value;
                                                  final domSeleccionado =
                                                      dominios.firstWhere(
                                                        (dom) =>
                                                            dom['ID']
                                                                .toString() ==
                                                            value,
                                                      );
                                                  _dominioController.text =
                                                      domSeleccionado['Domain'];
                                                });
                                              },
                                              validator: (value) =>
                                                  value == null
                                                  ? loc.hint_domain
                                                  : null,
                                            ),

                                            const SizedBox(height: 16),
                                            CustomTextFormField(
                                              controller: _quotaController,
                                              label: loc.label_quota,
                                              hint: loc.hint_quota,
                                              icon: Icons.storage,
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) =>
                                                  value == null || value.isEmpty
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
                                              validator: (value) =>
                                                  value == null || value.isEmpty
                                                  ? loc.field_required
                                                  : null,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ------------------ TAB 2: Contraseña ------------------
                            SingleChildScrollView(
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(
                                    color: Color.fromARGB(255, 61, 130, 240),
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Form(
                                    key: _passwordFormKey,
                                    child: Column(
                                      children: [
                                        PasswordField(
                                          label_text: loc.old_password,
                                          controller: _passwordController,
                                          edit: true,
                                        ),
                                        const SizedBox(height: 16),
                                        PasswordField(
                                          label_text: loc.new_password,
                                          controller: _passwordNewController,
                                          edit: true,
                                        ),
                                        const SizedBox(height: 16),
                                        ConfirmPasswordField(
                                          controller:
                                              _confirmPasswordController,
                                          originalPasswordController:
                                              _passwordNewController,
                                          edit: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ------------------ Botones abajo ------------------
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) =>
              Center(child: Text('Error al cargar dominios: $err')),
        ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _submitForm(ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 39, 122, 47),
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
