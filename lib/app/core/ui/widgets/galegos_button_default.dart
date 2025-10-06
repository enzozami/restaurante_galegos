import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';

class GalegosButtonDefault extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double? heigth;

  const GalegosButtonDefault({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 200,
    this.heigth = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: heigth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: GalegosUiDefaut.theme.elevatedButtonTheme.style,
        // style: ElevatedButton.styleFrom(
        //   backgroundColor: Colors.black,
        // ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
      ),
    );
  }
}
