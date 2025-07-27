import 'package:flutter/material.dart';

class ButtonHome extends StatelessWidget {
  const ButtonHome({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      },
      backgroundColor: Colors.blue,
      child: const Icon(Icons.home, color: Colors.white),
    );
  }
}
