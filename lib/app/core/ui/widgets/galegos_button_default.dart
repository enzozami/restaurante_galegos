import 'package:flutter/material.dart';

class GalegosButtonDefault extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const GalegosButtonDefault({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
