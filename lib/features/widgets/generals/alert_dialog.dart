import 'package:flutter/material.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';

class ConfirmAlertDialog extends StatelessWidget {
  final String text;

  const ConfirmAlertDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

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
            TextSpan(text: loc.delete_confirmation),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            loc.cancel,
            style: TextStyle(color: const Color.fromARGB(255, 56, 55, 55)),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(loc.delete, style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
