import 'package:flutter/material.dart';

class GalegosButtonDefault extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double? heigth;
  final Icon? icon;

  const GalegosButtonDefault({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 200,
    this.heigth = 50,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: heigth,
      child: ElevatedButton.icon(
        style: Theme.of(context).elevatedButtonTheme.style,
        onPressed: onPressed,
        label: Text(label),
        icon: icon,
      ),
    );
  }
}
