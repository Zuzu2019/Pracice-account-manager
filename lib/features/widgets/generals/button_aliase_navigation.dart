import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/aliases/models/aliases.dart';
import 'package:practice_acount_manager/features/aliases/presentation/pages/alias_page.dart';
import 'package:practice_acount_manager/features/aliases/presentation/pages/frm_add_aliase.dart';
import 'package:practice_acount_manager/features/aliases/providers/alias_provider.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';

enum ButtonAction { addAliase, listAliase }

class ButtonOptionsAliase extends ConsumerStatefulWidget {
  const ButtonOptionsAliase({super.key});

  @override
  ConsumerState<ButtonOptionsAliase> createState() =>
      _ButtonOptionsAliaseState();
}

class _ButtonOptionsAliaseState extends ConsumerState<ButtonOptionsAliase> {
  ButtonAction? _selectedAction;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _selectedAction = ButtonAction.addAliase;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddAliasForm(
                      alias: Aliases(local: '', remoto: '', id: 0),
                      isEditing: false,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.person_add),
              label: Text(loc.add_alias),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedAction == ButtonAction.addAliase
                    ? const Color.fromARGB(255, 0, 100, 255)
                    : const Color.fromARGB(255, 7, 156, 255),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _selectedAction = ButtonAction.listAliase;
                });

                ref.read(aliasProvider.notifier).reload();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AliasPage()),
                );
              },
              icon: const Icon(Icons.list),
              label: Text(loc.list),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedAction == ButtonAction.listAliase
                    ? const Color.fromARGB(255, 0, 100, 255)
                    : const Color.fromARGB(255, 7, 156, 255),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
