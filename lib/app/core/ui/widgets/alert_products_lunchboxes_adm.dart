import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

class AlertProductsLunchboxesAdm extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String body;
  const AlertProductsLunchboxesAdm({
    super.key,
    required this.onPressed,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: GalegosUiDefaut.colorScheme.onPrimary,
      titlePadding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      actionsPadding: const EdgeInsets.all(20),
      title: Text(
        title,
        style: TextStyle(
          color: GalegosUiDefaut.colorScheme.primary,
        ),
      ),
      content: Text(
        body,
        style: TextStyle(
          color: GalegosUiDefaut.colorScheme.primary,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: GalegosUiDefaut.theme.elevatedButtonTheme.style,
          child: Text('Fechar'),
        ),
        ElevatedButton(
          onPressed: onPressed,
          style: GalegosUiDefaut.theme.elevatedButtonTheme.style,
          child: Text('Confirmar'),
        ),
      ],
    );
  }
}
