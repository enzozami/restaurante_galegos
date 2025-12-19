import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_button_default.dart';

class AlertDialogConfirmExit extends StatelessWidget {
  final VoidCallback onPressed;
  const AlertDialogConfirmExit({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sair da conta?'),
      content: Text('Tem certeza de que deseja encerrar sua sessão atual?'),
      actionsAlignment: .spaceAround,
      actions: [
        GalegosButtonDefault(
          label: 'Cancelar',
          width: context.widthTransformer(reducedBy: 70),
          onPressed: () {
            Get.back();
          },
        ),
        GalegosButtonDefault(
          label: 'Sair',
          onPressed: onPressed,
          width: context.widthTransformer(reducedBy: 70),
        ),
      ],
    );
  }
}
