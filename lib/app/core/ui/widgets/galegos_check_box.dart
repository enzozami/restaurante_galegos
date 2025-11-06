import 'package:flutter/material.dart';

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
      checkColor: Colors.amber,
      side: BorderSide(
        color: Colors.black,
      ),
      value: isChecked,
      onChanged: onChanged,
    );
  }
}
