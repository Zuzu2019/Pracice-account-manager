import 'package:flutter/material.dart';

class ConfirmAlertDialog extends StatelessWidget {
  final String text;

  const ConfirmAlertDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: RichText(
        //textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            color: const Color.fromARGB(255, 36, 35, 35),
            fontSize: 14,
          ), // estilo base
          children: [
            TextSpan(
              text: text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' se va a eliminar. ¿Está seguro de continuar?'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancelar',
            style: TextStyle(color: const Color.fromARGB(255, 56, 55, 55)),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Eliminar', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
