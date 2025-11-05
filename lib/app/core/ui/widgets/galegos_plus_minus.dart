import 'package:flutter/material.dart';

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
            color: color ?? Colors.white,
          ),
        ),
        Text(
          '$quantityUnit',
          style: TextStyle(
            color: Color(0xFFE2933C),
          ),
        ),
        IconButton(
          onPressed: addCallback,
          icon: Icon(
            Icons.add,
            color: color ?? Colors.white,
          ),
        ),
      ],
    );
  }
}
