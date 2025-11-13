import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class GalegosTextFormField extends StatelessWidget {
  final String? label;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final bool obscureText;
  final MaskTextInputFormatter? mask;
  final TextInputType inputType;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool? enabled;
  final IconButton? icon;
  final ValueChanged<String>? onChanged;
  final Color? colorText;
  final Color? colorBorder;

  const GalegosTextFormField({
    super.key,
    this.controller,
    this.label,
    this.validator,
    this.obscureText = false,
    this.mask,
    this.inputType = TextInputType.text,
    this.enabled,
    required this.floatingLabelBehavior,
    this.icon,
    this.onChanged,
    this.colorText,
    this.colorBorder,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: inputType,
      validator: validator,
      onChanged: onChanged,
      inputFormatters: [
        if (mask != null) mask!,
      ],
      style: TextStyle(
        color: colorText ?? Colors.black,
      ),
      decoration: InputDecoration(
        // suffixIcon: icon
        labelText: label,
        suffixIcon: icon,
        floatingLabelBehavior: floatingLabelBehavior,
        hintStyle: TextStyle(
          color: colorText ?? Colors.black,
        ),
        labelStyle: TextStyle(
          color: colorBorder ?? Colors.black,
        ),
        enabled: enabled ?? false,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: colorBorder ?? Colors.black,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: colorBorder ?? Colors.black,
          ),
        ),
        floatingLabelStyle: TextStyle(
          color: colorText ?? Colors.black,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: colorBorder ?? Colors.black,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
      cursorColor: colorText ?? Colors.black,
    );
  }
}
