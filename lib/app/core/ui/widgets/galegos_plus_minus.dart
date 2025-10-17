import 'package:flutter/material.dart';

class GalegosPlusMinus extends StatelessWidget {
  final VoidCallback addCallback;
  final VoidCallback removeCallback;
  final int quantityUnit;
  const GalegosPlusMinus({
    super.key,
    required this.addCallback,
    required this.removeCallback,
    required this.quantityUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: removeCallback,
          icon: Icon(
            Icons.remove,
            color: Colors.white,
          ),
        ),
        Text(
          '$quantityUnit',
          style: TextStyle(
            color: Colors.amber,
          ),
        ),
        IconButton(
          onPressed: addCallback,
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
