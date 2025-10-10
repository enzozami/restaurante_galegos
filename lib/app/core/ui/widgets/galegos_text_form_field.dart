import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class GalegosTextFormField extends StatelessWidget {
  final String label;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final bool obscureText;
  final MaskTextInputFormatter? mask;
  final TextInputType inputType;

  const GalegosTextFormField({
    super.key,
    this.controller,
    required this.label,
    this.validator,
    this.obscureText = false,
    this.mask,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      validator: validator,
      inputFormatters: [
        if (mask != null) mask!,
      ],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
      cursorColor: Colors.black,
    );
  }
}
