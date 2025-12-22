import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Icon? prefixIcon;
  final ValueChanged<String>? onChanged;
  final Color? colorText;
  final Color? colorBorder;
  final String? prefixText;
  final String? suffixText;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final String? hintText;
  final Widget Function(
    BuildContext context, {
    required int currentLength,
    required int? maxLength,
    required bool isFocused,
  })?
  buildCounter;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLines;
  final int? minLines;

  const GalegosTextFormField({
    super.key,
    this.label,
    this.validator,
    this.controller,
    this.obscureText = false,
    this.mask,
    this.inputType = TextInputType.text,
    required this.floatingLabelBehavior,
    this.enabled,
    this.icon,
    this.prefixIcon,
    this.onChanged,
    this.colorText,
    this.colorBorder,
    this.prefixText,
    this.suffixText,
    this.focusNode,
    this.onEditingComplete,
    this.textInputAction,
    this.maxLength,
    this.maxLengthEnforcement,
    this.buildCounter,
    this.hintText,
    this.inputFormatter,
    this.maxLines,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      buildCounter: buildCounter,
      enabled: enabled,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      textInputAction: textInputAction,
      keyboardType: inputType,
      onEditingComplete: onEditingComplete,
      validator: validator,
      onChanged: onChanged,
      inputFormatters:
          inputFormatter ??
          [
            if (mask != null) mask!,
          ],
      style: TextStyle(
        color: colorText ?? Colors.black,
      ),
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: icon,
        prefixText: prefixText,
        suffixText: suffixText,
        floatingLabelBehavior: floatingLabelBehavior,
        hintStyle: TextStyle(
          color: colorText ?? Colors.black,
        ),
        labelStyle: TextStyle(
          color: colorBorder ?? Colors.black,
        ),
        enabled: enabled ?? true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: colorBorder ?? Colors.black,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: colorBorder ?? Colors.black,
          ),
        ),
        floatingLabelStyle: TextStyle(
          color: colorText ?? Colors.black,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: colorBorder ?? Colors.black,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
      cursorColor: colorText ?? Colors.black,
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
    );
  }
}
