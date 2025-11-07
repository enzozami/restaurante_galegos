import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

class AlertProductsLunchboxesAdm extends StatelessWidget {
  final VoidCallback onPressed;
  const AlertProductsLunchboxesAdm({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: GalegosUiDefaut.colorScheme.onPrimary,
      titlePadding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      actionsPadding: const EdgeInsets.all(20),
      title: Text(
        'Atenção',
        style: TextStyle(
          color: GalegosUiDefaut.colorScheme.primary,
        ),
      ),
      content: Text(
        'Você deseja desabilitar esse item?',
        style: TextStyle(
          color: GalegosUiDefaut.colorScheme.primary,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {},
          child: Text('Fechar'),
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: Text('Sim'),
        ),
      ],
    );
  }
}
