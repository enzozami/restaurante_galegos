import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';

class GalegosTextFormField extends StatelessWidget {
  final String? label;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final bool obscureText;
  final MaskTextInputFormatter? mask;
  final TextInputType inputType;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool? enabled;
  final IconData? suffixIcon;
  final VoidCallback? onPressed;
  final IconData? prefixIcon;
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
  final bool prefix;
  final bool suffix;
  final bool? filled;
  final Color? fillColor;

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
    this.suffixIcon,
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
    this.onPressed,
    required this.prefix,
    required this.suffix,
    this.filled,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final isPressed = false.obs;
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
        color: colorText ?? AppColors.title,
      ),
      focusNode: focusNode,
      decoration: InputDecoration(
        filled: filled,
        fillColor: fillColor,
        labelText: label,
        hintText: hintText,
        prefixIcon: prefix
            ? Icon(
                prefixIcon,
                color: AppColors.title,
              )
            : null,
        suffixIcon: suffix
            ? Obx(() {
                final scale = isPressed.value ? 0.97 : 1.0;
                return GestureDetector(
                  onTapDown: (_) => isPressed.value = true,
                  onTapUp: (_) => isPressed.value = false,
                  onTapCancel: () => isPressed.value = false,
                  child: AnimatedScale(
                    scale: scale,
                    duration: const Duration(milliseconds: 80),
                    child: IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        suffixIcon,
                        color: AppColors.title,
                      ),
                    ),
                  ),
                );
              })
            : null,
        prefixText: prefixText,
        suffixText: suffixText,
        floatingLabelBehavior: floatingLabelBehavior,
        hintStyle: TextStyle(
          color: colorText ?? AppColors.title,
        ),
        labelStyle: TextStyle(
          color: colorBorder ?? AppColors.title,
        ),
        enabled: enabled ?? true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: colorBorder ?? AppColors.title,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: colorBorder ?? AppColors.title,
          ),
        ),
        floatingLabelStyle: TextStyle(
          color: colorText ?? AppColors.title,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: colorBorder ?? AppColors.title,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
      cursorColor: colorText ?? AppColors.title,
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
    );
  }
}
