import 'package:flutter/material.dart';
import 'package:practice_acount_manager/features/users/presentation/components/search_table_user.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_home.dart';
import 'package:practice_acount_manager/features/widgets/generals/button_user_navigation.dart';
import 'package:practice_acount_manager/features/widgets/generals/drawer.dart';
import 'package:practice_acount_manager/features/widgets/generals/footer.dart';
import 'package:practice_acount_manager/features/widgets/generals/search_bar.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Usuarios',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
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
            const SearchBarExample(),
            const SizedBox(height: 20),
            const Center(child: ButtonOptions()),
            
            SizedBox(width: double.infinity, child: const SearchTableUser()),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
      floatingActionButton: const ButtonHome(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
