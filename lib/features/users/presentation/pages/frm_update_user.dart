import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:practice_acount_manager/features/users/presentation/components/input_password_confirm_user.dart';
import 'package:practice_acount_manager/features/users/presentation/models/users.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_cancel.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_user_navigation.dart';
import 'package:practice_acount_manager/features/widgets/generals/footer.dart';
import 'package:practice_acount_manager/features/users/presentation/components/input_password_user.dart';

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
  late final TextEditingController _idController;
  late final TextEditingController _groupController;
  late final TextEditingController _quotaController;
  late final TextEditingController _dominioController;

  String? _selectedDomain;
  String? dominio;

  @override
  void initState() {
    super.initState();

    final email = widget.user.email;
    final dominio = email.contains('@') ? email.split('@')[1] : '';

    _loginController = TextEditingController(text: widget.user.login);
    _idController = TextEditingController(text: widget.user.identificacion);
    _groupController = TextEditingController(text: widget.user.grupo);
    _quotaController = TextEditingController(text: widget.user.quota);
    _dominioController = TextEditingController(text: dominio);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: 'Las contraseñas no coinciden',
          btnOkOnPress: () {},
        ).show();
        return;
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'User actualizado',
        desc: 'Usuario actualizado correctamente',
        btnOkOnPress: () {
          Navigator.pop(context, '');
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
    final title = 'Editar usuario';
    final btnText = 'Actualizar';

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
            const ButtonOptions(),
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
                          labelText: 'Login',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 25, 0, 255),
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Escribe tu usuario',
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
                            ? 'Campo obligatorio'
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

                      TextFormField(
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: 'Identificador',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 25, 0, 255),
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Escribe el ID del usuario',
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
                            ? 'Campo obligatorio'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _groupController,
                        decoration: InputDecoration(
                          labelText: 'Grupo',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 25, 0, 255),
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Ingrese el grupo',
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
                            ? 'Campo obligatorio'
                            : null,
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Dominio',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 25, 0, 255),
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Selecciona un dominio',
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
                            value == null ? 'Seleccione un dominio' : null,
                      ),

                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _quotaController,
                        decoration: InputDecoration(
                          labelText: 'Quota',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 25, 0, 255),
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: 'Ingresa la cuota',
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
                            ? 'Campo obligatorio'
                            : null,
                      ),

                      const SizedBox(height: 32),

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
