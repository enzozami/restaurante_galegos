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
    // com o Get.put, variável NÃO é resetada quando o build rodar
    final RxBool isPressed = Get.put(false.obs, tag: label);

    return Obx(() {
      final scale = isPressed.value ? 0.97 : 1.00;
      return GestureDetector(
        onTap: () async {
          isPressed.value = true;
          await 80.milliseconds.delay();
          isPressed.value = false;
          onPressed!();
        },
        onTapDown: (_) => isPressed.value = true,
        onTapUp: (_) => isPressed.value = false,
        onTapCancel: () => isPressed.value = false,
        behavior: .opaque,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeInOut,
          child: SizedBox(
            width: width,
            height: heigth,
            child: IgnorePointer(
              child: icon != null
                  ? ElevatedButton.icon(
                      style: style,
                      // onPressed: onPressed,
                      onPressed: () {},
                      label: Text(label),
                      icon: icon!,
                    )
                  : ElevatedButton(
                      style: style,
                      // onPressed: onPressed,
                      onPressed: () {},
                      child: Text(label),
                    ),
            ),
          ),
        ),
      );
    });
  }
}
