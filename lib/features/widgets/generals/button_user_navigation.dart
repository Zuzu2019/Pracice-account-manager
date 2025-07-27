import 'package:flutter/material.dart';
import 'package:practice_acount_manager/features/users/presentation/pages/frm_add_user.dart';
import 'package:practice_acount_manager/features/users/presentation/pages/users_page.dart';

enum ButtonAction { addUser, listUsers }

class ButtonOptions extends StatefulWidget {
  const ButtonOptions({super.key});

  @override
  State<ButtonOptions> createState() => _ButtonOptionsState();
}

class _ButtonOptionsState extends State<ButtonOptions> {
  ButtonAction? selectedAction;

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
                  selectedAction = ButtonAction.addUser;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddUserForm()),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Nuevo Usuario'),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedAction == ButtonAction.addUser
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
                  selectedAction = ButtonAction.listUsers;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UsersPage()),
                );
              },
              icon: const Icon(Icons.list),
              label: const Text('Listado'),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedAction == ButtonAction.listUsers
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
