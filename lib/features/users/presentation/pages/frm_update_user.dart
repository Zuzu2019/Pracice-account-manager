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

class UpdateUserForm extends ConsumerStatefulWidget {
  final User user;

  const UpdateUserForm({super.key, required this.user});

  @override
  ConsumerState<UpdateUserForm> createState() => _AddUserFormState();
}

// Con SingleTickerProviderStateMixin para manejar el TabController
class _AddUserFormState extends ConsumerState<UpdateUserForm>
    with SingleTickerProviderStateMixin {
  final _generalFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  late TextEditingController _loginController;
  late TextEditingController _emailController;
  late TextEditingController _groupController;
  late TextEditingController _quotaController;
  late TextEditingController _identificacionController;
  late TextEditingController _dominioController;

  final _passwordController = TextEditingController();
  final _passwordNewController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late TabController _tabController;
  final _isLoading = StateProvider<bool>((ref) => false);

  int? _selectedDomain;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _loginController = TextEditingController(text: widget.user.login);
    _emailController = TextEditingController(text: widget.user.email);
    _groupController = TextEditingController(text: widget.user.grupo);
    _quotaController = TextEditingController(
      text: widget.user.quota.toString(),
    );
    _identificacionController = TextEditingController(
      text: widget.user.identificacion,
    );

    _selectedDomain = widget.user.dominio;
    _dominioController = TextEditingController(
      text: widget.user.dominio != 0 ? '@dominio.com' : '',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userFormProvider.notifier).loadUserForForm(widget.user.id);
    });
  }

  @override
  void dispose() {
    _loginController.dispose();
    _emailController.dispose();
    _groupController.dispose();
    _quotaController.dispose();
    _identificacionController.dispose();
    _dominioController.dispose();

    _passwordController.dispose();
    _passwordNewController.dispose();
    _confirmPasswordController.dispose();

    _tabController.dispose();
    super.dispose();
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

  // Ahora el método recibe el TabController como argumento
  void _submitForm(WidgetRef ref, TabController tabController) async {
    final loc = AppLocalizations.of(context)!;

    // Usamos el TabController pasado como argumento
    if (tabController.index == 0) {
      final isGeneralValid = _generalFormKey.currentState?.validate() ?? false;
      if (!isGeneralValid) return;

      final user = User(
        dominio: _selectedDomain != null
            ? (_selectedDomain!)
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
        final firstMessage = errors.values.first;
        _showDialog(
          context: context,
          title: 'Error',
          description: firstMessage ?? 'Error en el formulario',
          btnColor: Colors.red,
        );
        return;
      }

      ref.read(_isLoading.notifier).state = true;
      try {
        await ref.read(userProvider.notifier).updateUsers(user, user.id);
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
        );
      } finally {
        ref.read(_isLoading.notifier).state = false;
      }
    } else if (tabController.index == 1) {
      final isPasswordValid =
          _passwordFormKey.currentState?.validate() ?? false;
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
      } finally {
        ref.read(_isLoading.notifier).state = false;
      }
    }
  }

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
      dismissOnTouchOutside: false,
      dialogType: type,
      title: title,
      desc: description,
      btnOkOnPress: onOk ?? () {},
      btnOkColor: btnColor,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<User>(userFormProvider, (previous, next) {
      if (previous != next) {
        _loginController.text = next.login;
        _emailController.text = next.email;
        _groupController.text = next.grupo;
        _quotaController.text = next.quota.toString();
        _identificacionController.text = next.identificacion;
        _dominioController.text = next.dominio != 0 ? '@dominio.com' : '';
        setState(() {
          _selectedDomain = next.dominio;
        });
      }
    });
    final loc = AppLocalizations.of(context)!;
    final title = loc.edit_user_title;
    final btnText = loc.update_button;
    final dominiosAsync = ref.watch(dominiosProvider);
    final isLoading = ref.watch(_isLoading);

    return Stack(
      children: [
        Scaffold(
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
            data: (dominios) => Column(
              children: [
                ButtonOptions(),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: const [
                    Tab(text: 'General'),
                    Tab(text: 'Contraseña'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
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
                                  DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      labelText: loc.label_domain,
                                      prefixIcon: const Icon(Icons.domain),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    value:
                                        dominios.any(
                                          (dom) => dom['ID'] == _selectedDomain,
                                        )
                                        ? _selectedDomain
                                        : null,
                                    items: dominios
                                        .map<DropdownMenuItem<int>>(
                                          (dom) => DropdownMenuItem<int>(
                                            value: dom['ID'] as int,
                                            child: Text(dom['Domain']),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedDomain = value;
                                        if (value != null) {
                                          final domSeleccionado = dominios
                                              .firstWhere(
                                                (dom) => dom['ID'] == value,
                                              );
                                          _dominioController.text =
                                              domSeleccionado['Domain'];
                                          _updateEmail();
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextFormField(
                                    controller: _quotaController,
                                    label: loc.label_quota,
                                    hint: loc.hint_quota,
                                    icon: Icons.storage,
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomTextFormField(
                                    controller: _emailController,
                                    label: loc.email,
                                    hint: '',
                                    icon: Icons.email,
                                    readOnly: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
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
                                    controller: _confirmPasswordController,
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
                  onPressed: () => _submitForm(
                    ref,
                    _tabController,
                  ), // Pasar el controlador aquí
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

        if (isLoading)
          Container(
            color: Colors.black45,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
