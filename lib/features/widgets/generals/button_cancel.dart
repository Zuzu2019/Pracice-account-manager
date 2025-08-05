import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:practice_acount_manager/l10n/app_localizations.dart';

class ButtonCancel extends StatelessWidget {
  const ButtonCancel({super.key});

  void _showCancelConfirmation(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      title: loc.cancel,
      desc: loc.cancelConfirmation,
      btnCancelText: 'No',
      btnOkText: loc.cancel,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return ElevatedButton(
      onPressed: () => _showCancelConfirmation(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 177, 43, 34),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(loc.cancel),
    );
  }
}
