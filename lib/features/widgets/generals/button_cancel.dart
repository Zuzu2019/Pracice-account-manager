import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ButtonCancel extends StatelessWidget {
  const ButtonCancel({super.key});

  void _showCancelConfirmation(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      title: '¿Cancelar?',
      desc: '¿Estás seguro de que deseas cancelar?',
      btnCancelText: 'No',
      btnOkText: 'Sí, Cancelar',
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
    return ElevatedButton(
      onPressed: () => _showCancelConfirmation(context),
      child: const Text('Cancelar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
