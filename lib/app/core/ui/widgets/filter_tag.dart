import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/models/category_model.dart';

class FilterTag extends StatelessWidget {
  final CategoryModel? category;
  final String? days;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterTag({
    super.key,
    this.category,
    this.isSelected = false,
    required this.onPressed,
    this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(15),
            constraints: BoxConstraints(minHeight: 40, minWidth: 130),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(30),
              color: isSelected
                  ? GalegosUiDefaut.colorScheme.primary
                  : GalegosUiDefaut.colorScheme.tertiary,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                category?.name ?? days ?? '',
                style: TextStyle(
                  color: isSelected
                      ? GalegosUiDefaut.colorScheme.tertiary
                      : GalegosUiDefaut.colors['fundo'],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
