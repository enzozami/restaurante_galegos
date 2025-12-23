import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/models/category_model.dart';

class FilterTag extends StatelessWidget {
  final CategoryModel? category;
  final String? days;
  final String? status;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterTag({
    super.key,
    this.category,
    this.isSelected = false,
    required this.onPressed,
    this.days,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.tertiary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: theme.colorScheme.tertiary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Text(
            category?.name ?? days ?? status ?? '',
            style: TextStyle(
              color: isSelected ? theme.colorScheme.tertiary : theme.colorScheme.surface,
            ),
          ),
        ),
      ),
    );
  }
}
