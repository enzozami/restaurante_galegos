import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/core/ui/galegos_ui_defaut.dart';
import 'package:restaurante_galegos/app/models/product_model.dart';

class FilterTag extends StatelessWidget {
  final ProductModel model;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterTag({
    super.key,
    required this.model,
    this.isSelected = false,
    required this.onPressed,
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
            constraints: BoxConstraints(
              minHeight: 40,
              minWidth: 130,
            ),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(30),
              color: isSelected ? GalegosUiDefaut.colorScheme.primary : Colors.black,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                model.categoryId,
                style: TextStyle(
                  color: isSelected ? Colors.black : GalegosUiDefaut.colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
