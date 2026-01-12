import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurante_galegos/app/core/ui/theme/app_colors.dart';

mixin MessagesMixin on GetxController {
  void messageListener(Rxn<MessageModel> message) {
    ever<MessageModel?>(
      message,
      (model) async {
        if (model != null) {
          // await 100.milliseconds.delay();
          Get.rawSnackbar(
            titleText: Text(
              model.title,
              style: TextStyle(
                color: model.type.textColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            messageText: Text(
              model.message,
              style: TextStyle(color: model.type.textColor()),
            ),
            backgroundColor: model.type.color() ?? Colors.grey,
            margin: const EdgeInsets.all(20),
            borderRadius: 10,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 1),
            isDismissible: true,
            overlayBlur: 0,
          );
          message.value = null;
          // await 100.milliseconds.delay();
        }
      },
    );
  }
}

class MessageModel {
  final String title;
  final String message;
  final MessageType type;

  MessageModel({
    required this.title,
    required this.message,
    required this.type,
  });
}

enum MessageType { error, info }

extension MessageTypeColorExt on MessageType {
  Color? color() {
    switch (this) {
      case MessageType.error:
        return Colors.red[800]!;
      case MessageType.info:
        return AppColors.primary;
    }
  }

  Color textColor() {
    switch (this) {
      case MessageType.error:
        return Colors.white;
      case MessageType.info:
        return Colors.black;
    }
  }
}
