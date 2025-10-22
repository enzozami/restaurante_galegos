import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';

class ProfileData extends StatelessWidget {
  final String label;
  final String title;
  final TextEditingController controller;
  final bool isSelected;
  final VoidCallback onPressed;
  final bool? obscure;

  const ProfileData({
    required this.controller,
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
    required this.title,
    this.obscure,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Text(title),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: context.widthTransformer(reducedBy: 20),
                child: GalegosTextFormField(
                  label: label,
                  controller: controller,
                  enabled: isSelected,
                  obscureText: obscure ?? false,
                ),
              ),
              IconButton(
                onPressed: onPressed,
                icon: isSelected ? Icon(Icons.close) : Icon(Icons.edit),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
