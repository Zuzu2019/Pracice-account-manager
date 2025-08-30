import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/aliases/models/aliases.dart';
import 'package:practice_acount_manager/features/aliases/providers/alias_provider.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_aliase_navigation.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_cancel.dart';
import 'package:practice_acount_manager/features/widgets/generals/footer.dart';
import 'package:practice_acount_manager/features/widgets/generals/text_form_field.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';
import 'package:practice_acount_manager/riverpod/auth_provider.dart';

class AddAliasForm extends ConsumerStatefulWidget {
  final Aliases alias;
  final bool isEditing;

  const AddAliasForm({super.key, required this.alias, this.isEditing = false});
  @override
  ConsumerState<AddAliasForm> createState() => _AddAliasFormState();
}

class _AddAliasFormState extends ConsumerState<AddAliasForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _localController;
  late final TextEditingController _remotoController;
  late final TextEditingController _idController;
  late final accessToken = ref.read(authProvider).accessToken;

  final _isLoading = StateProvider<bool>((ref) => false);

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
      final alias = Aliases(
        id: int.tryParse(_idController.text.trim()) ?? 0,
        local: _localController.text.trim(),
        remoto: _remotoController.text.trim(),
      );
      ref.read(_isLoading.notifier).state = true;

      if (widget.isEditing) {
        try {
          await ref.read(aliasProvider.notifier).updateAlias(alias, id);

          AwesomeDialog(
            context: context,
            dismissOnTouchOutside: false,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: loc.alias_updated,
            desc: loc.alias_updated_successfully,
            btnOkOnPress: () {
              Navigator.pop(context);
            },
            btnOkColor: Colors.blue,
          ).show();
        } catch (e) {
          AwesomeDialog(
            context: context,
            dismissOnTouchOutside: false,
            dialogType: DialogType.error,
            title: loc.error_title,
            desc: e.toString(),
            btnOkOnPress: () {},
            btnOkColor: Colors.red,
          ).show();
        } finally {
          ref.read(_isLoading.notifier).state = false;
        }
      } else {
        try {
          await ref.read(aliasProvider.notifier).addAlias(alias);

          AwesomeDialog(
            context: context,
            dismissOnTouchOutside: false,
            dialogType: DialogType.success,
            animType: AnimType.leftSlide,
            title: loc.success_title,
            desc: loc.alias_added_successfully,
            btnOkOnPress: () {
              _formKey.currentState!.reset();
              _localController.clear();
              _remotoController.clear();
            },
            btnOkColor: Colors.green,
          ).show();
        } catch (e) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            dismissOnTouchOutside: false,
            title: loc.error_title,
            desc: e.toString(),
            btnOkOnPress: () {},
            btnOkColor: Colors.red,
          ).show();
        } finally {
          ref.read(_isLoading.notifier).state = false;
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
    final isLoading = ref.watch(_isLoading);
    return Stack(
      children: [
        Scaffold(
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
