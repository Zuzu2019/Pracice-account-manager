import 'package:flutter/material.dart';
import 'package:practice_acount_manager/features/aliases/presentation/components/search_table_alias.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_aliase_navigation.dart';
import 'package:practice_acount_manager/features/widgets/generals/drawer.dart';
import 'package:practice_acount_manager/features/widgets/generals/footer.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';

class AliasPage extends StatelessWidget {
  const AliasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.aliasManagement,
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
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: ButtonOptionsAliase()),
            SizedBox(height: 20),

            //SearchBarExample(),
            SizedBox(child: SearchTableAliases()),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
      //floatingActionButton: const ButtonHome(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
