import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_acount_manager/features/aliases/presentation/pages/alias_page.dart';
import 'package:practice_acount_manager/features/users/presentation/pages/users_page.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';
import 'package:practice_acount_manager/main.dart';
import 'package:practice_acount_manager/riverpod/statenotifier.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    return SizedBox(
      width: 230,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 195, 204, 255),
                    Color.fromARGB(255, 0, 140, 255),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  loc.menu,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.indigo),
              title: Text(
                loc.home,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.alternate_email, color: Colors.indigo),
              title: Text(
                loc.aliases,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AliasPage()),
                );
              },
            ),
            //const Divider(),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.indigo),
              title: Text(
                loc.users,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UsersPage()),
                );
              },
            ),
            //const Divider(),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Color.fromARGB(255, 172, 49, 49),
              ),
              title: Text(
                loc.logout,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  animType: AnimType.bottomSlide,
                  title: loc.logout,
                  desc: loc.logout_confirmation,
                  btnCancelText: loc.cancel,
                  btnCancelOnPress: () {},
                  btnOkText: loc.confirm,
                  btnOkOnPress: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ).show();
              },
            ),

            ListTile(
              leading: const Icon(Icons.language, color: Colors.indigo),
              title: Text(
                (loc.change_language), // Usa tus traducciones aquí
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(loc.select_language),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Español'),
                          onTap: () {
                            ref
                                .read(localeProvider.notifier)
                                .setLocale(Locale('es'));
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('English'),
                          onTap: () {
                            ref
                                .read(localeProvider.notifier)
                                .setLocale(Locale('en'));
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
