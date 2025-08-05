import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:practice_acount_manager/features/users/presentation/components/input_password_confirm_user.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_cancel.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_user_navigation.dart';
import 'package:practice_acount_manager/features/widgets/generals/footer.dart';
import 'package:practice_acount_manager/features/users/presentation/components/input_password_user.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';

class AddUserForm extends StatefulWidget {
  const AddUserForm({super.key});

  @override
  State<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final TextEditingController _loginController;
  late final TextEditingController _idController;
  late final TextEditingController _groupController;
  late final TextEditingController _quotaController;
  late final TextEditingController _dominioController;

  String? _selectedDomain;
  String? dominio;

  @override
  void initState() {
    super.initState();

    // Nueva inserción: campos vacíos
    _loginController = TextEditingController();
    _idController = TextEditingController();
    _groupController = TextEditingController();
    _quotaController = TextEditingController();
    _dominioController = TextEditingController();
  }

  void _submitForm(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: loc.errorTitle,
          desc: loc.password_mismatch,
          btnOkOnPress: () {},
        ).show();
        return;
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: loc.successTitle,
        desc: loc.userAddedSuccessfully,
        btnOkOnPress: () {
          _formKey.currentState!.reset();
          _loginController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
          _idController.clear();
          _groupController.clear();
          _quotaController.clear();
          setState(() => _selectedDomain = null);
        },
        btnOkColor: Colors.green,
      ).show();
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _idController.dispose();
    _groupController.dispose();
    _quotaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Agregar usuario';

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
                      TextFormField(
                        controller: _loginController,
                        decoration: InputDecoration(
                          //labelText: 'Login',
                          //labelText:.label_login,
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 25, 0, 255),
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: loc.hint_login, // Usar la localización
                          //hintText: 'Escribe tu usuario',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.person,
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
                        validator: (value) => value == null || value.isEmpty
                            ? loc
                                  .field_required //'Campo obligatorio'
                            : null,
                      ),

                      const SizedBox(height: 16),

                      PasswordField(
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

                      TextFormField(
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: loc.label_id, //'Identificador',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 25, 0, 255),
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: loc.hint_id, //'Escribe el ID del usuario',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.verified_user,
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
                        validator: (value) => value == null || value.isEmpty
                            ? loc
                                  .field_required //'Campo obligatorio'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _groupController,
                        decoration: InputDecoration(
                          labelText: loc.label_group, //'Grupo',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 25, 0, 255),
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: loc.hint_group, //'Ingrese el grupo',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.group,
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
                        validator: (value) => value == null || value.isEmpty
                            ? loc
                                  .field_required //'Campo obligatorio'
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
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedDomain = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? loc.hint_domain : null,
                      ),

                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _quotaController,
                        decoration: InputDecoration(
                          labelText: loc.label_quota, //'Quota',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 25, 0, 255),
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: loc.hint_quota, //'Ingresa la cuota',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(
                            Icons.storage,
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
                        validator: (value) => value == null || value.isEmpty
                            ? loc
                                  .field_required //'Campo obligatorio'
                            : null,
                      ),

                      const SizedBox(height: 32),

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
