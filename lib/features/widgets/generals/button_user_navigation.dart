import 'package:flutter/material.dart';
import 'package:practice_acount_manager/features/users/presentation/pages/frm_add_user.dart';
import 'package:practice_acount_manager/features/users/presentation/pages/users_page.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';

enum ButtonAction { addUser, listUsers }

class ButtonOptions extends StatefulWidget {
  //final void Function(Locale) onLocaleChange;
  const ButtonOptions({super.key});

  @override
  State<ButtonOptions> createState() => _ButtonOptionsState();
}

class _ButtonOptionsState extends State<ButtonOptions> {
  ButtonAction? selectedAction;

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
                  selectedAction = ButtonAction.addUser;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddUserForm()),
                );
              },
              icon: const Icon(Icons.person_add),
              label: Text(loc.title_add_user),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedAction == ButtonAction.addUser
                    ? const Color.fromARGB(255, 0, 100, 255)
                    : const Color.fromARGB(255, 7, 156, 255),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
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
                  selectedAction = ButtonAction.listUsers;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UsersPage()),
                );
              },
              icon: const Icon(Icons.list),
              label: Text(loc.list),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedAction == ButtonAction.listUsers
                    ? const Color.fromARGB(255, 0, 100, 255)
                    : const Color.fromARGB(255, 7, 156, 255),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
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
