import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalegosButtonDefault extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double? heigth;
  final Icon? icon;
  final ButtonStyle? style;

  const GalegosButtonDefault({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.heigth = 50,
    this.icon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final RxBool isPressed = false.obs;
    return Obx(() {
      final scale = isPressed.value ? 0.97 : 1.00;
      return GestureDetector(
        onTapDown: (_) => isPressed.value = true,
        onTapUp: (_) => isPressed.value = false,
        onTapCancel: () => isPressed.value = false,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeInOut,
          child: SizedBox(
            width: width,
            height: heigth,
            child: icon != null
                ? ElevatedButton.icon(
                    style: style,
                    onPressed: onPressed,
                    label: Text(label),
                    icon: icon!,
                  )
                : ElevatedButton(
                    style: style,
                    onPressed: onPressed,
                    child: Text(label),
                  ),
          ),
        ),
      );
    });
  }
}
