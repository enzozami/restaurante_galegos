import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

class GalegosCheckBox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const GalegosCheckBox({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: GalegosUiDefaut.colorScheme.onPrimary,
      side: BorderSide(
        color: Colors.black,
      ),
      value: isChecked,
      onChanged: onChanged,
    );
  }
}
