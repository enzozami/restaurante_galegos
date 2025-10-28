import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:restaurante_galegos/app/core/ui/widgets/galegos_text_form_field.dart';

class ProfileData extends StatelessWidget {
  final String title;
  final String label;
  final TextEditingController? controller;
  final bool? isSelected;
  final bool? obscure;
  final FormFieldValidator<String>? validator;

  const ProfileData({
    this.controller,
    super.key,
    required this.label,
    this.isSelected,
    required this.title,
    this.obscure,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final maskedLabel = obscure == true ? '••••••••' : label;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Text(title),
          ),
          SizedBox(
            width: context.widthTransformer(reducedBy: 10),
            child: GalegosTextFormField(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              label: (isSelected != null && isSelected == true) ? label : maskedLabel,
              controller: controller,
              enabled: isSelected ?? true,
              obscureText: obscure ?? false,
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
