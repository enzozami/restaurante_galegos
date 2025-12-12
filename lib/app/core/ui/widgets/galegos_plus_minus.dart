import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

class GalegosPlusMinus extends StatelessWidget {
  final VoidCallback addCallback;
  final VoidCallback removeCallback;
  final Color? color;
  final int quantityUnit;
  const GalegosPlusMinus({
    super.key,
    required this.addCallback,
    required this.removeCallback,
    required this.quantityUnit,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: removeCallback,
          icon: Icon(
            Icons.remove,
            color: GalegosUiDefaut.colorScheme.tertiary,
          ),
        ),
        Text(
          '$quantityUnit',
          style: TextStyle(
            color: GalegosUiDefaut.colorScheme.primary,
          ),
        ),
        IconButton(
          onPressed: addCallback,
          icon: Icon(
            Icons.add,
            color: GalegosUiDefaut.colorScheme.tertiary,
          ),
        ),
      ],
    );
  }
}
