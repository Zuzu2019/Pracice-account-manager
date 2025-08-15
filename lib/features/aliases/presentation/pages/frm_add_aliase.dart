import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:practice_acount_manager/features/aliases/data/alias_service.dart';
import 'package:practice_acount_manager/features/aliases/models/aliases.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_aliase_navigation.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_cancel.dart';
import 'package:practice_acount_manager/features/widgets/generals/footer.dart';
import 'package:practice_acount_manager/features/widgets/generals/text_form_field.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';

class AddAliasForm extends StatefulWidget {
  final Aliases alias;
  final bool isEditing;

  const AddAliasForm({super.key, required this.alias, this.isEditing = false});
  @override
  State<AddAliasForm> createState() => _AddAliasFormState();
}

class _AddAliasFormState extends State<AddAliasForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _localController;
  late final TextEditingController _remotoController;
  late final TextEditingController _idController;

  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.alias.id.toString());
    _localController = TextEditingController(text: widget.alias.local);
    _remotoController = TextEditingController(text: widget.alias.remoto);
  }

  void _submitForm(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final id = int.tryParse(_idController.text.trim()) ?? 0;

    if (_formKey.currentState!.validate()) {
      final updateAliases = Aliases(
        id: int.tryParse(_idController.text.trim()) ?? 0,
        local: _localController.text.trim(),
        remoto: _remotoController.text.trim(),
      );

      if (widget.isEditing) {
        try {
          final resp = await updateAlias(id, updateAliases, 'token');

          if (resp.statusCode == 200 || resp.statusCode == 201) {
            await AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.rightSlide,
              title: loc.alias_updated,
              desc: loc.alias_updated_successfully,
              btnOkOnPress: () {
                Navigator.pop(context, updateAliases);
              },
              btnOkColor: Colors.blue,
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
          await AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: loc.error_title,
            desc: 'Error al actualizar alias: $e',
            btnOkOnPress: () {
              Navigator.pop(context);
            },
            btnOkColor: Colors.red,
          ).show();
        }
      } else {
        final resp = await saveAlias(updateAliases, 'token');

        if (resp.statusCode == 200) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: loc.success_title,
            desc: loc.alias_added_successfully,
            btnOkOnPress: () {
              _formKey.currentState!.reset();
              _localController.clear();
              _remotoController.clear();
            },
            btnOkColor: Colors.green,
          ).show();
        } else {
          String errorMessage = resp.body.isNotEmpty
              ? resp.body
              : 'Error inesperado: Código ${resp.statusCode}';

          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: loc.error_title,
            desc: errorMessage,
            btnOkOnPress: () {
              // _formKey.currentState!.reset();
              // _localController.clear();
              // _remotoController.clear();
            },
            btnOkColor: Colors.red,
          ).show();
        }
      }
    }
  }

  @override
  void dispose() {
    _localController.dispose();
    _remotoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final title = widget.isEditing ? loc.edit_alias : loc.add_alias;
    final btnText = widget.isEditing ? loc.update_button : loc.button_add;

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
            ButtonOptionsAliase(),
            const SizedBox(height: 30),
            const SizedBox(height: 16),
            Card(
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
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: _localController,
                        label: loc.local_label,
                        hint: loc.local_alias_hint,
                        icon: Icons.person,
                        validator: (value) => value == null || value.isEmpty
                            ? loc.field_required
                            : null,
                      ),

                      const SizedBox(height: 16),

                      CustomTextFormField(
                        controller: _remotoController,
                        label: loc.remote_label,
                        hint: loc.remote_alias_hint,
                        icon: Icons.cloud,
                        validator: (value) => value == null || value.isEmpty
                            ? loc.field_required
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
