import 'package:flutter/material.dart';

class GalegosButtonDefault extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double? heigth;
  final Icon? icon;
  final ButtonStyle? style;

  const GalegosButtonDefault({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.heigth = 50,
    this.icon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: heigth,
      child: icon != null
          ? ElevatedButton.icon(
              style: style,
              onPressed: onPressed,
              label: Text(label),
              icon: icon!,
            )
          : ElevatedButton(
              style: style,
              onPressed: onPressed,
              child: Text(label),
            ),
    );
  }
}
