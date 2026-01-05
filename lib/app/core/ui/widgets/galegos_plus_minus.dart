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
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisSize: .min,
      spacing: 15,
      children: [
        IconButton(
          onPressed: removeCallback,
          padding: .zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
          icon: Icon(
            Icons.remove,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          '$quantityUnit',
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
        ),
        IconButton(
          onPressed: addCallback,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
          icon: Icon(
            Icons.add,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
