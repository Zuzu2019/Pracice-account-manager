import 'package:flutter/material.dart';

class TimedLoadingExample extends StatefulWidget {
  const TimedLoadingExample({super.key});

  @override
  State<TimedLoadingExample> createState() => _TimedLoadingExampleState();
}

class _TimedLoadingExampleState extends State<TimedLoadingExample> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    // 🔹 Ocultar el CircularProgress después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : const Text("Contenido cargado!"),
      ),
    );
  }
}
