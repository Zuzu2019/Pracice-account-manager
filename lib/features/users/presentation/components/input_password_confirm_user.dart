import 'package:flutter/material.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';

class ConfirmPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController originalPasswordController;
  final bool edit;

  const ConfirmPasswordField({
    super.key,
    required this.controller,
    required this.originalPasswordController,
    required this.edit,
  });

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  bool _obscure = true;

  void _toggleVisibility() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: loc.label_confirm_password,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 25, 0, 255),
          fontWeight: FontWeight.bold,
        ),
        hintText: loc.confirm_password_hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 0, 0, 0)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          onPressed: _toggleVisibility,
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
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
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (value) {
        if (widget.edit == false) {
          if (value == null || value.isEmpty) {
            return loc.field_required;
          } // No validation needed for editing
        }

        if (value != widget.originalPasswordController.text) {
          return loc.password_mismatch;
        }

        return null;
      },
    );
  }
}
