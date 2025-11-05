import 'package:flutter/material.dart';

class ButtonTag extends StatelessWidget {
  final String model;
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
      splashColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(
          minHeight: 40,
          minWidth: 190,
        ),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Color(0xFFE2933C) : Colors.black,
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            model.isNotEmpty ? model[0].toUpperCase() + model.substring(1) : model,
            style: TextStyle(
              color: isSelected ? Colors.black : Color(0xFFE2933C),
            ),
          ),
        ),
      ),
    );
  }
}
