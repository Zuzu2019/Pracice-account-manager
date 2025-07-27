import 'package:flutter/material.dart';
import 'package:practice_acount_manager/features/aliases/presentation/pages/alias_page.dart';
import 'package:practice_acount_manager/features/aliases/presentation/pages/frm_add_aliase.dart';

enum ButtonAction { addAliase, listAliase }

class ButtonOptionsAliase extends StatefulWidget {
  const ButtonOptionsAliase({super.key});

  @override
  State<ButtonOptionsAliase> createState() => _ButtonOptionsAliaseState();
}

class _ButtonOptionsAliaseState extends State<ButtonOptionsAliase> {
  ButtonAction? _selectedAction;

  @override
  Widget build(BuildContext context) {
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
                  MaterialPageRoute(builder: (_) => const AddAliasForm()),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Nuevo Alias'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedAction == ButtonAction.addAliase
                    ? const Color.fromARGB(255, 0, 100, 255)
                    : const Color.fromARGB(255, 7, 156, 255),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _selectedAction = ButtonAction.listAliase;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AliasPage()),
                );
              },
              icon: const Icon(Icons.list),
              label: const Text('Listado'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedAction == ButtonAction.listAliase
                    ? const Color.fromARGB(255, 0, 100, 255)
                    : const Color.fromARGB(255, 7, 156, 255),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
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
