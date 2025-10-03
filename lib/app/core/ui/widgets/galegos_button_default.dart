import 'package:flutter/material.dart';

class GalegosButtonDefault extends StatelessWidget {
  final Color? color;
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double? heigth;

  const GalegosButtonDefault({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 200,
    this.heigth = 80,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: heigth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
          ),
        ),
      ),
    );
  }
}
