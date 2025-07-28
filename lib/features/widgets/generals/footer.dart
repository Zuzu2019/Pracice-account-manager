import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 54, 84, 255),
        borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
      ),
      child: const Text(
        'Copyright © 2025, FireClub. All rights reserved.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}
