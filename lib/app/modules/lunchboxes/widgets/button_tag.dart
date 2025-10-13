import 'package:flutter/material.dart';
import 'package:restaurante_galegos/app/models/day_model.dart';

import 'package:restaurante_galegos/app/models/menu_model.dart';

class ButtonTag extends StatelessWidget {
  final DayModel model;
  final bool isSelected;
  final VoidCallback onPressed;

  const ButtonTag({
    super.key,
    required this.model,
    this.isSelected = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
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
          color: isSelected ? Colors.amber : Colors.black,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            model.day,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.amber,
            ),
          ),
        ),
      ),
    );
  }
}
