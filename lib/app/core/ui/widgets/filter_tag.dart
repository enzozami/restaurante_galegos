import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/models/category_model.dart';

class FilterTag extends StatelessWidget {
  final CategoryModel? category;
  final String? days;
  final String? status;
  final bool isSelected;
  final VoidCallback onPressed;
  final Function(TapDownDetails) onTapDown;
  final Function(TapUpDetails) onTapUp;
  final Function() onTapCancel;
  final Rxn<CategoryModel>? isPressedCategory;
  final Rxn<String>? isPressedDay;
  final Rxn<String>? isPressedStatus;

  const FilterTag({
    super.key,
    this.category,
    this.isSelected = false,
    required this.onPressed,
    this.days,
    this.status,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    this.isPressedCategory,
    this.isPressedDay,
    this.isPressedStatus,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Obx(() {
      final bool pressed =
          (category != null && category!.name == isPressedCategory?.value?.name) ||
          (days != null && days == isPressedDay?.value) ||
          (status != null && status == isPressedStatus?.value);
      return GestureDetector(
        onTap: onPressed,
        onTapDown: onTapDown,
        onTapCancel: onTapCancel,
        onTapUp: onTapUp,
        behavior: .opaque,
        child: AnimatedScale(
          scale: (pressed) ? 0.95 : (isSelected ? 1.05 : 1.0),
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
    });
  }
}
